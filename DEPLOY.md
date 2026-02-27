# Gratis Gast Deployment Guide

## 🚀 Quick Start

### 1. Create GitHub Repo

```bash
# Create new repo on GitHub: gratisgast
# Then push this code:
git init
git add .
git commit -m "Initial commit: Gratis Gast website"
git remote add origin https://github.com/YOUR_USERNAME/gratisgast.git
git push -u origin main
```

---

## 📱 Frontend (Vercel)

### Step 1: Connect to Vercel
1. Go to [vercel.com](https://vercel.com)
2. Import GitHub repo
3. Set **Root Directory** to `frontend/`
4. Framework: **Other** (static HTML)
5. Deploy

### Step 2: Custom Domain
1. Buy `gratisgast.nl` (TransIP, SIDN, or Cloudflare)
2. Add domain in Vercel project settings
3. Update DNS records as instructed

### Step 3: Environment Variables
None needed for frontend.

---

## 🔧 Backend (Railway)

### Step 1: Create Project
1. Go to [railway.app](https://railway.app)
2. New Project → Deploy from GitHub repo
3. Select `gratisgast` repo
4. Set **Root Directory** to `backend/`

### Step 2: Add PostgreSQL
1. Click "New" → Database → Add PostgreSQL
2. Railway auto-sets `DATABASE_URL`

### Step 3: Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `DATABASE_URL` | (auto) | PostgreSQL connection |
| `EMAIL_USER` | gast@gratisgast.nl | Gmail address |
| `EMAIL_PASS` | xxx | Gmail App Password |
| `FRONTEND_URL` | https://gratisgast.nl | Your domain |
| `NODE_ENV` | production | Environment |

**Get Gmail App Password:**
1. Google Account → Security → 2-Step Verification
2. App passwords → Generate
3. Use 16-character password

### Step 4: Deploy
Railway auto-deploys on push.

### Step 5: Custom Domain
1. Railway Settings → Domains
2. Add `api.gratisgast.nl`
3. Update DNS CNAME record

---

## 🔗 Connect Frontend to Backend

Update `frontend/index.html`:

```javascript
const API_URL = 'https://api.gratisgast.nl/api';
```

Commit and push — Vercel auto-deploys.

---

## ✅ Testing

### Frontend
```bash
cd frontend
npx serve .
# Open http://localhost:3000
```

### Backend
```bash
cd backend
npm install
npm run dev
# Test: curl http://localhost:3000/api/health
```

### Production Test
1. Visit `https://gratisgast.nl`
2. Fill email form
3. Check inbox for welcome email
4. Check Railway logs for errors

---

## 📊 Monitoring

### Railway Dashboard
- Logs: Real-time API requests
- Metrics: CPU, memory, DB connections
- Deployments: Rollback if needed

### Vercel Dashboard
- Analytics: Page views, Core Web Vitals
- Deployments: Preview builds
- Domains: SSL status

---

## 🔄 Update Workflow

```bash
# Make changes
git add .
git commit -m "Update: new section"
git push

# Auto-deploys to:
# - Vercel (frontend)
# - Railway (backend)
```

---

## 🆘 Troubleshooting

| Issue | Fix |
|-------|-----|
| Email not sending | Check Gmail App Password, less secure apps |
| DB connection fail | Verify `DATABASE_URL` in Railway |
| CORS errors | Update `FRONTEND_URL` in backend env |
| Form not working | Check API_URL points to Railway domain |

---

## 🎯 Next Steps

1. [ ] Buy domain `gratisgast.nl`
2. [ ] Set up Gmail account + App Password
3. [ ] Deploy to Vercel
4. [ ] Deploy to Railway
5. [ ] Connect custom domains
6. [ ] Test email capture end-to-end
7. [ ] Share on social media

---

*Gratis Gast — Waarom betalen als het gratis kan?*
