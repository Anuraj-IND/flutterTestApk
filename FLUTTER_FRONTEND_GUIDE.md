# Covermint — Flutter Frontend Guide (LC / Lead Generator Panel)

> **For: Flutter developer** — build the LG app against the live backend at `https://multilevelcrm.onrender.com`
> **Backend docs:** Swagger UI `GET /api-docs` + spec `GET /openapi.json` + `docs/API_REFERENCE.md`
> **Bottom-up plan:** LC is phase 1. Same base URL, JWT, and `openapi/` contract will be extended for RM / ISP / HR / CRM / ERP / Accounts / Agreements.

---

## 1. Stack & Config

| Item | Value |
|---|---|
| **Base URL (prod)** | `https://multilevelcrm.onrender.com` |
| **Base URL (local)** | `http://localhost:10000` — `git clone` + `npm install` + fill `.env` + `npm start` |
| **Swagger UI** | `GET /api-docs` — expand any endpoint → Try it out shows real body + example |
| **OpenAPI source** | `openapi/parts/*.js` → `openapi/index.js` → `src/swagger.js` (single truth) |
| **DB** | Supabase Postgres — session pooler `aws-0-ap-southeast-1.pooler.supabase.com:5432` (IPv4), direct host is IPv6-only |
| **Storage** | Supabase Storage bucket `lg-docs` (private, uploads return signed URLs `?token=...`, 1-yr expiry) |
| **Auth** | Phone-OTP → JWT `Authorization: Bearer <token>`. `OTP_MODE=dev` → bypass `123456` everywhere |
| **Display LG-ID** | Integer `lg_seq`, starts at **12345** (`lgs.lg_seq` serial, `SELECT setval(...,12344)` on fresh DB) |

**`pubspec.yaml` deps:** `http` or `dio`, `flutter_secure_storage` (JWT), `image_picker` + `file_picker` (image/pdf), `go_router` or `auto_route`.

**Env (inject via `--dart-define`):** `API_BASE=https://multilevelcrm.onrender.com`

---

## 2. Full User Workflow (what the app must do)

```
[Screen 1: Register Step 1]  name, phone(OTP), mail, PAN ──POST /register/init──> draft_id
         │  Validate PHONE_RE ^[6-9]\d{9}$ , PAN_RE ^[A-Z]{5}[0-9]{4}[A-Z]$ client-side; server re-validates + 409 on duplicate PAN/phone
         │  OTP modal: POST /otp/verify {phone,otp:"123456"} — no Next until verified
         ▼
[Screen 2: Register Step 2 — single scroll window]
  ┌─ Non-editable header (echo from GET /register/:draftId: name, phone, mail, pan_no) ─┐
  │  Address block: address_as_per_aadhaar, pincode ^[1-9][0-9]{5}$, current address/location │
  │  RM block: RM name, RM number (typed; backend auto-creates RM stub if phone not found)  │
  │  Banking block: bank name, branch, IFSC ^[A-Z]{4}0[A-Z0-9]{6}$, account no, bank address │
  │    └─ On IFSC field blur → POST /utils/ifsc/verify {ifsc} (free Razorpay proxy, cached 30d) │
  │       autofill/validate bank+branch+address; final gate re-verifies live on submit       │
  │  Docs block (image or PDF, ≤5MB each): aadhaar_front, aadhaar_back, pan_card, cheque    │
  │    └─ POST /register/:draftId/documents  multipart fields of those 4 names               │
  │  TOS row: checkbox DISABLED until overlay fully scrolled                                  │
  │    └─ Tap → bottom-sheet overlay: GET /tos?version=latest (full text), header [name + date/time] │
  │       require scroll-to-bottom detection before enabling Accept; on Accept → POST        │
  │       /register/:draftId/tos-accept {name,tos_version,scrolled_complete:true} (stores   │
  │       ip/ua/timestamp; 400 unless scrolled_complete) → checkbox becomes tickable         │
  └─────────────────────────────────────────────────────────────────────────────────────────┘
         │  Submit button enabled ONLY when: phone_verified + address+RМ+banking filled + IFSC ok
         │  + 4 docs uploaded + TOS accepted. POST /register/:draftId/submit (server re-checks all
         │  + live IFSC). 201 → {lg_id uuid, lg_seq, verification_status:"pending"} or 400 gate msg
         ▼
[Screen 3: Dashboard]  GET /me/dashboard (Bearer JWT from POST /login/verify)
  LG-ID (lg_seq), name, phone, aadhaar (masked XXXX-XXXX-****, full is PII-encrypted, do not expect), 
  mailID, RM name + phone, ISP name (ISP = Insurance Specified Person), PO name (Principal Officer) 
  — last two are random strings for now, later FK-linked. Verification badge: pending/approved/rejected,
  is_active flag. Pull-to-refresh. Logout clears JWT.
         │  Sell button (prominent CTA on dashboard)
         ▼
[Screen 4: Sell Hub]  GET /catalog/insurance  (no auth) — cards: Life | Motor | Health
  Each card → its own flow; for now POST /intents/policy {category,payload} (stub, full per-product
  APIs come in phase 2). Show "Coming soon" detail but wire the intent call so backend work is unblocked.
         │
[Bottom nav — always visible: Lead | Renewal | Performance]  (all stubs, final shapes below)
```

All writes + every CSV export are audit-logged server-side (`audit_logs`, `events_outbox`). Never filter auth-only on the client.

---

## 3. Screens — What to Build

### S1 · Register Step 1 (`/register`)
Fields: name*, phone* (+ Send OTP / Verify inline), mail*, PAN* . Validations:
- phone `^[6-9]\d{9}$`, PAN `^[A-Z]{5}[0-9]{4}[A-Z]$` (uppercase before submit), email `^[^\s@]+@[^\s@]+\.[^\s@]+$`.
- UX: Next button disabled until `POST /register/init` 201 + `POST /otp/verify` 200. Show 409 error if PAN/phone already registered.

### S2 · Register Step 2 (`/register/:draftId`)
Single scrollable page (not a wizard). Sections:
1. **Read-only echo** — `GET /register/:draftId` → name/phone/mail/PAN as styled non-editable rows (gray, no cursor). Also show existing `documents` + `tos` progress if user returns.
2. **Address + RM** — text fields + pincode validation. RM number is optional but should be collected; hint: "Your Relationship Manager's name & phone".
3. **Banking** — bankName*, branch, IFSC* (mask `XXXX0XXXXXX`, uppercase), accountNo*, bankAddress. IFSC field: debounce → `POST /utils/ifsc/verify` → green check + autofill bank/branch/address or red "Invalid IFSC".
4. **Documents** — 4 upload tiles (aadhaar front/back, PAN card, cheque copy). Accept gallery, camera, or file (pdf). Show picked state + re-pick to re-upload (versioned on server). Client limit 5 MB — check `File.length()` before upload.
5. **TOS** — checkbox disabled grey → tap label/checkbox opens overlay. Overlay: scrollable full TOS (`GET /tos`), sticky header "I, <name>, on <now>", Accept button disabled until `ScrollNotification` reaches max extent → `POST /tos-accept`. On success, checkbox ticks. Error if not scrolled: `scrolled_complete must be true`.
6. **Submit** — disabled (grey) until all gates; enabled (brand color). On tap `POST /submit` → success → persist nothing yet; loader → auto-redirect to login then dashboard.

Handle 400 gate errors: server returns `{error:"missing document: cheque"}` etc — map to inline banner.

### S3 · Dashboard (`/dashboard`, authed)
Header: LG-ID large (`#12345`), verification pill (pending amber / approved green / rejected red).
Card rows: `Name | Phone | Mail | Aadhaar (masked) | RM — Name · Phone | ISP | PO`.
CTA: **Sell** (full-width primary button) → Sell Hub.
Include: logout button (clears `flutter_secure_storage`), pull-to-refresh (`GET /dashboard`).
Do NOT try to display full Aadhaar — backend returns `XXXX-XXXX-**** (encrypted at rest)` by design.

### S4 · Sell Hub (`/sell`)
Fetched from `GET /catalog/insurance`. Grid/list of 3 cards with icons:
- **Life Insurance** → `POST /intents/policy {category:"life", payload:{}}` then placeholder detail page
- **Motor Insurance** → same with `motor`
- **Health Insurance** → same with `health`
Each detail page can be a single "Coming soon — we'll notify you" for now; the intent call proves the wiring. Show success snackbar with returned `id`.

### Bottom Nav (Scaffold, always visible: slot on S3 & S4)
3 tabs using `BottomNavigationBar`:
- **Lead** → `GET /me/leads` — stub returns `{data:[], page, total}`. Render empty state "No leads yet" + illustration. Same table will later feed ISP report.
- **Renewal** → `GET /me/renewals` — stub `{data:[], buckets:{d30:0,d60:0,d90:0}}`. Show 3 bucket chips.
- **Performance** → `GET /me/performance` — `{leads_generated, conversion_pct, commission_earned}` + note. Show KPI cards with 0s.

Keep tab state in a shared `ShellRoute`/provider so switching tabs doesn't lose scroll position.

---

## 4. API Wiring (copy-paste ready)

Base: `https://multilevelcrm.onrender.com` (open `.../api-docs` → Try it out fills bodies for you).

| Step | Call | Body |
|---|---|---|
| 1 | `POST /api/lg/register/init` | `{name,phone,email,pan_no}` → `draft_id` |
|   | `POST /api/lg/otp/send` | `{phone, purpose:"register"}` (dev: `{dev:true}`) |
|   | `POST /api/lg/otp/verify` | `{phone,otp:"123456", purpose:"register"}` |
| 2 | `GET  /api/lg/register/:draftId` | echo |
|   | `PATCH /api/lg/register/:draftId` | `{address_aadhaar,pincode,current_address,rm_name,rm_number,aadhaar_no,banking:{bank_name,branch,ifsc,account_number,bank_address}}` |
|   | `POST /api/utils/ifsc/verify` | `{ifsc}` → `{bank,branch,address,verified}` |
|   | `POST /api/lg/register/:draftId/documents` | multipart `aadhaar_front,aadhaar_back,pan_card,cheque` (each `image/*` or `application/pdf`) |
|   | `GET  /api/tos?version=latest` | TOS text |
|   | `POST /api/lg/register/:draftId/tos-accept` | `{name,tos_version,scrolled_complete:true}` |
|   | `POST /api/lg/register/:draftId/submit` | (empty) → `lg_seq` |
| 3 | `POST /api/lg/otp/send` | `{phone, purpose:"login"}` |
|   | `POST /api/lg/login/verify` | `{phone,otp}` → `{token, lg_seq, id}` — store token |
|   | `GET  /api/lg/me/dashboard` | `Authorization: Bearer <token>` |
| 4 | `GET  /api/lg/catalog/insurance` | 3 categories |
|   | `POST /api/lg/intents/policy` | `Bearer` + `{category:"life"|"motor"|"health", payload}` |
| Tabs | `GET /api/lg/me/leads` / `renewals` / `performance` | `Bearer` |
| Staff (later) | `GET /api/lg` · `GET /api/lg/export` · `PATCH /api/lg/:id/verify` · `PATCH /api/lg/:id/active` | `Bearer` |

All lists: `?type=&verification=&search=&page=&limit=` support. CSV export: `GET /api/lg/export` → `Covermint_LG_Report_<date>.csv` (UTF-8, same filtered set, audited).

**`dio` interceptor:** attach `Authorization`, auto-logout on 401, map `{error}` to `SnackBar`.

---

## 5. UX & State Rules

- **Validation duality:** validate client-side for speed, but every gate re-validates server-side — always show the server `{error}` if 400.
- **TOS overlay:** must gate on scroll-to-bottom, not just screen time. Use `NotificationListener<ScrollNotification>`; enable Accept only when `pixels >= maxScrollExtent - 8`.
- **Files:** show preview thumbnail for images, file icon + size for PDFs. Reject >5 MB locally before upload; mip `multer` enforces it server-side.
- **Submit button:** purely a reflection of local gate checks; server may still 400 with a specific missing field — surface it.
- **Token storage:** `flutter_secure_storage` (`kSecuredLGToken`); clear on logout. Guard `/*` beyond `/register` & `/login` with an `AuthGuard`.
- **Error/empty:** `No parameters` seen in Swagger is fixed — full schemas are now in `openapi/parts/*.js`. For empty tab data show `No data found` + bounce to retry.
- **Branding:** placeholder brand colors — keep them as `ThemeData` constants so swapping to Covermint palette is one file.
- **No diagrams here by request** — ASCII flows above are the only visuals.

---

## 6. Folder Suggestion

```
lib/
  core/api/dio_client.dart   # baseUrl=API_BASE, interceptors
  features/
    register/data, presentation/{step1_screen.dart, step2_screen.dart, tos_sheet.dart}
    dashboard/{dashboard_screen.dart}
    sell/{sell_hub_screen.dart, product_detail_screen.dart}
    tabs/{leads_tab.dart, renewals_tab.dart, performance_tab.dart}
  shared/widgets/{upload_tile.dart, ifsc_field.dart, tos_checkbox.dart}
```

---

## 7. Quick Smoke (confirm backend is up)

```
curl https://multilevelcrm.onrender.com/health
curl https://multilevelcrm.onrender.com/api-docs   # Swagger
curl https://multilevelcrm.onrender.com/openapi.json | jq .paths | head
flutter run --dart-define=API_BASE=https://multilevelcrm.onrender.com
```

Full local E2E (backend): `npm start` then `node e2e-lc.js` — init→OTP(123456)→step2→4 docs→TOS→submit(#12345)→login→dashboard→sell→tabs→verify.

> Hand this file to the Flutter dev; every screen + endpoint + validation is here. When life/motor/health detail APIs land, only `openapi/parts/*.js` + `docs/API_REFERENCE.md` grow — same base URL & JWT.
