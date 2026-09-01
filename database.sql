-- Create the bookings table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.bookings (
    id TEXT PRIMARY KEY,
    user_email TEXT NOT NULL,
    train_id TEXT NOT NULL,
    train_name TEXT NOT NULL,
    departure_station TEXT NOT NULL,
    arrival_station TEXT NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    passenger_count INTEGER NOT NULL,
    total_price NUMERIC NOT NULL,
    status TEXT NOT NULL,
    booking_date TIMESTAMP NOT NULL DEFAULT NOW(),
    seat_class TEXT,
    passengers JSONB,
    country TEXT NOT NULL DEFAULT 'India'
);

-- Create index on user_email for faster lookups
CREATE INDEX IF NOT EXISTS bookings_user_email_idx ON public.bookings(user_email);

-- Grant necessary permissions
GRANT ALL ON public.bookings TO authenticated;
GRANT ALL ON public.bookings TO service_role;
