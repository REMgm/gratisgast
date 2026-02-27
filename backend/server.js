const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const nodemailer = require('nodemailer');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Middleware
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000'
}));
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10 // limit each IP to 10 requests per windowMs
});
app.use('/api/', limiter);

// Email transporter
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// Initialize database
async function initDB() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS subscribers (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        source VARCHAR(100) DEFAULT 'website',
        subscribed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        active BOOLEAN DEFAULT true
      )
    `);
    console.log('✅ Database initialized');
  } catch (err) {
    console.error('❌ Database error:', err);
  }
}

// Routes

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Subscribe to newsletter
app.post('/api/subscribe', async (req, res) => {
  const { email, source = 'website' } = req.body;
  
  if (!email || !email.includes('@')) {
    return res.status(400).json({ error: 'Valid email required' });
  }
  
  try {
    // Insert subscriber
    await pool.query(
      'INSERT INTO subscribers (email, source) VALUES ($1, $2) ON CONFLICT (email) DO NOTHING',
      [email.toLowerCase(), source]
    );
    
    // Send welcome email
    await transporter.sendMail({
      from: '"Gratis Gast" <gast@gratisgast.nl>',
      to: email,
      subject: 'Welkom bij Gratis Gast! 🎯',
      html: `
        <h1>Hoi!</h1>
        <p>Bedankt voor je aanmelding. Ik stuur je een mail als ik iets nieuws ontdek.</p>
        <p>En onthoud: <strong>waarom betalen als het gratis kan?</strong></p>
        <br>
        <p>- Gast</p>
        <p><a href="https://gratisgast.nl">GratisGast.nl</a></p>
      `
    });
    
    res.json({ success: true, message: 'Subscribed!' });
  } catch (err) {
    console.error('Subscribe error:', err);
    res.status(500).json({ error: 'Something went wrong' });
  }
});

// Get subscriber count (admin)
app.get('/api/subscribers/count', async (req, res) => {
  // Add auth middleware in production
  try {
    const result = await pool.query('SELECT COUNT(*) FROM subscribers WHERE active = true');
    res.json({ count: parseInt(result.rows[0].count) });
  } catch (err) {
    res.status(500).json({ error: 'Database error' });
  }
});

// Start server
initDB().then(() => {
  app.listen(PORT, () => {
    console.log(`🚀 Gratis Gast API running on port ${PORT}`);
  });
});
