# BREAKPOINT Owner Dashboard Setup

Dashboard page: https://lkwebforge-design.github.io/breakpoint/dashboard.html

Supabase project: `hatoqeuhxlycphxbqpyc`

## What is implemented

- Owner sign-in using Supabase Auth email/password.
- An explicit owner allow-list in `public.owner_users`.
- Booking list with customer contact, reference, table, date/time, duration, notes and status.
- Search and status/date filters.
- Owner actions: pending → confirmed/cancelled; confirmed → arrived/cancelled/no-show; arrived → completed/no-show.
- Booking access is protected by Row Level Security. The public website does not receive direct booking-table access; booking creation continues through the existing Edge Function.

## One-time owner setup

1. In the Supabase dashboard, open **Authentication → Users**.
2. Invite/create the client's owner account using **breakpointbilliardclub00@gmail.com**. The owner must finish the invite and set a password.
3. In **SQL Editor**, run:

   ```sql
   insert into public.owner_users (user_id)
   select id
   from auth.users
   where lower(email) = lower('breakpointbilliardclub00@gmail.com')
   on conflict (user_id) do nothing;
   ```

4. Open the dashboard URL above and sign in with that email and the password set for the Supabase Auth account.
5. Test with a non-sensitive test booking. Confirm it, then verify it appears as Confirmed and that an overlapping booking is rejected by the booking backend.

## Security notes

- Never put the Supabase service-role/secret key in this page or in GitHub.
- Only add trusted owner accounts to `public.owner_users`.
- Do not add public RLS policies to read booking records.
- The dashboard uses a publishable key, Supabase Auth, and RLS. The hard-coded owner email is an extra UI guard, not the database authorization boundary; the `owner_users` RLS check is the actual allow-list.
- Keep the client's Supabase project under an account/organization they control where practical, and document who owns ongoing maintenance.
- After changing database policies or grants, verify with Supabase Security Advisor and test that unauthenticated/public requests cannot read customer bookings.
