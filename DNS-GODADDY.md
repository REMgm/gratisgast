# DNS Setup for GratisGast.nl (GoDaddy)

## Step 1: Add Domain in Vercel
1. Go to https://vercel.com/dashboard
2. Click on "gratisgast" project
3. Go to Settings → Domains
4. Add "gratisgast.nl"
5. Vercel will show you the DNS records to add

## Step 2: Configure DNS in GoDaddy

Login to GoDaddy → My Products → DNS

### Add these records:

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | @ | 76.76.21.21 | 600 seconds |
| CNAME | www | cname.vercel-dns.com | 600 seconds |

### Or if Vercel gives you different values:
- **A Record**: Points root domain to Vercel IP
- **CNAME Record**: Points www to Vercel domain

## Step 3: Wait for Propagation
- DNS changes can take 24-48 hours (usually faster)
- Check status in Vercel dashboard

## Step 4: Verify
- Visit https://gratisgast.nl
- Should show your site

## Troubleshooting
- If not working after 48h, check DNS records are correct
- Make sure no conflicting A records exist
- Contact GoDaddy support if DNS not updating

---

**Current site:** https://gratisgast.vercel.app
**Target:** https://gratisgast.nl
