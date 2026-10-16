# Breakpoint — Billiards Booking Demo

A mobile-friendly, neon-inspired billiards booking front end for **Billiard Board 01**.

## What's in this first commit

- Responsive landing page and Board 01 feature card
- Booking form for date, start time, duration, customer name, phone and optional note
- Session summary and interactive sample time-slot selection
- WhatsApp contact link using the number supplied: +94 74 183 2377
- Supabase starter schema in `supabase/schema.sql`

## Important: this is a front-end demo

The booking form is intentionally labelled as a demo. It does **not** create a real reservation, check live availability, send WhatsApp notifications or save shared booking history yet. Slot buttons currently demonstrate the interaction only. Do not use this version to accept actual reservations.

## Next steps to make bookings live

1. Create a Supabase project.
2. Run `supabase/schema.sql` in the Supabase SQL Editor and review the security policies.
3. Add a server-side Supabase Edge Function to validate opening hours and allowed durations, prevent overlapping reservations, and save booking records.
4. Add authenticated owner access and a private dashboard for upcoming/past bookings, cancellation, arrival/completion status, opening hours and unavailable periods.
5. Configure WhatsApp Business Platform credentials as server-side secrets and notify the owner only after the booking has been committed successfully.
6. Connect the browser form to the Edge Function. Never put a Supabase service-role key or WhatsApp access token in public frontend code.

## Publish on GitHub Pages

Repository: https://github.com/lkwebforge-design/breakpoint

A GitHub Pages workflow is included in `.github/workflows/pages.yml`. In the repository settings, set **Pages → Build and deployment → Source** to **GitHub Actions** if it is not already selected. Once the workflow finishes, the likely site URL is:

https://lkwebforge-design.github.io/breakpoint/

If Pages is not enabled for the repository, the link may not load until that one-time setting is changed.

## Branding

“Breakpoint / Billiards” is placeholder demo branding. Replace it with the parlour's confirmed name and final imagery when available.
