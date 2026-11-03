-- Database setup for the shared scoreboard. Run in the Supabase SQL Editor.
-- Safe to re-run: every step either creates something new or replaces it.

-- The scores table. Names are 1-4 capital letters or digits; times are in seconds.
create table if not exists public.scores (
  id bigint generated always as identity primary key,
  name text not null check (name ~ '^[A-Z0-9]{1,4}$'),
  seconds numeric(7,2) not null,
  tasks smallint not null check (tasks between 1 and 4),
  created_at timestamptz not null default now()
);
create index if not exists scores_seconds_idx on public.scores (seconds desc);
create index if not exists scores_created_at_idx on public.scores (created_at desc);

-- No impossible times: by 15 minutes the game runs at more than 6x speed.
alter table public.scores drop constraint if exists scores_seconds_check;
alter table public.scores add constraint scores_seconds_check check (seconds > 0 and seconds <= 900);

-- Anyone can read scores and add one; nobody can change or delete them.
alter table public.scores enable row level security;
drop policy if exists "read scores" on public.scores;
drop policy if exists "add scores" on public.scores;
create policy "read scores" on public.scores for select to anon using (true);
create policy "add scores" on public.scores for insert to anon with check (true);

-- Players may only send a name, a time and a task count. The id and the timestamp
-- always come from the server, so nobody can backdate or future-date a score.
revoke insert, update, delete, truncate on public.scores from anon, authenticated;
grant insert (name, seconds, tasks) on public.scores to anon;

-- Flood protection: at most 20 new scores a minute and 2,000 a day, across all players.
create or replace function public.scores_rate_limit() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from public.scores where created_at > now() - interval '1 minute') >= 20
     or (select count(*) from public.scores where created_at > now() - interval '1 day') >= 2000 then
    raise exception 'Too many scores right now. Try again in a minute.';
  end if;
  return new;
end $$;
drop trigger if exists scores_rate_limit on public.scores;
create trigger scores_rate_limit before insert on public.scores
  for each row execute function public.scores_rate_limit();
