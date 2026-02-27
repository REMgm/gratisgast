# Gratis Gast

> Waarom betalen als het gratis kan?

De officiële AMEX Platinum referral site van Gratis Gast — gemaakt voor Nederlanders die slim willen leven.

## 🚀 Tech Stack

- **Frontend:** Static HTML/CSS (Vercel)
- **Backend:** Node.js/Express API (Railway)
- **Database:** PostgreSQL (Railway)
- **Email:** Nodemailer (Gmail SMTP)
- **Hosting:** GitHub → Vercel (frontend), Railway (backend)

## 📁 Project Structure

```
gratisgast/
├── frontend/          # Vercel deployment
│   ├── index.html
│   ├── styles.css
│   ├── images/
│   └── vercel.json
├── backend/           # Railway deployment
│   ├── server.js
│   ├── package.json
│   ├── .env.example
│   └── railway.json
└── README.md
```

## 🛠️ Local Development

### Frontend
```bash
cd frontend
npx serve .
```

### Backend
```bash
cd backend
npm install
npm run dev
```

## 🚀 Deployment

### Frontend (Vercel)
1. Push to GitHub
2. Connect repo to Vercel
3. Deploy automatically on push

### Backend (Railway)
1. Push to GitHub
2. Connect repo to Railway
3. Add environment variables
4. Deploy

## 📧 Email Capture API

**POST** `/api/subscribe`

```json
{
  "email": "gast@example.nl",
  "source": "website"
}
```

## 🔧 Environment Variables

See `.env.example` in backend folder.

## 📄 License

MIT — Gratis Gast 2026
