-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Drop existing tables if they exist
DROP TABLE IF EXISTS public.passengers;
DROP TABLE IF EXISTS public.train_classes;
DROP TABLE IF EXISTS public.train_schedules;
DROP TABLE IF EXISTS public.trains;
DROP TABLE IF EXISTS public.stations;
DROP TABLE IF EXISTS public.bookings;

-- Create stations table
CREATE TABLE public.stations (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  country TEXT NOT NULL,
  latitude NUMERIC(10,6),
  longitude NUMERIC(10,6),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create trains table
CREATE TABLE public.trains (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  train_number TEXT NOT NULL,
  train_name TEXT NOT NULL,
  country TEXT NOT NULL,
  operator TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create train_schedules table
CREATE TABLE public.train_schedules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  train_id UUID NOT NULL REFERENCES public.trains(id) ON DELETE CASCADE,
  departure_station TEXT NOT NULL,
  arrival_station TEXT NOT NULL,
  departure_time TEXT NOT NULL,
  arrival_time TEXT NOT NULL,
  duration INTEGER NOT NULL,
  days_of_operation TEXT[] NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create train_classes table
CREATE TABLE public.train_classes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  train_id UUID NOT NULL REFERENCES public.trains(id) ON DELETE CASCADE,
  class_code TEXT NOT NULL,
  class_name TEXT NOT NULL,
  description TEXT,
  base_price NUMERIC(10,2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE public.bookings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_email TEXT NOT NULL,
  train_id TEXT NOT NULL,
  train_name TEXT NOT NULL,
  departure_station TEXT NOT NULL,
  arrival_station TEXT NOT NULL,
  departure_time TEXT NOT NULL,
  arrival_time TEXT NOT NULL,
  travel_date TEXT NOT NULL,
  seat_class TEXT NOT NULL,
  total_amount NUMERIC(10,2) NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'pending',
  payment_method TEXT NOT NULL,
  booking_status TEXT NOT NULL DEFAULT 'confirmed',
  booking_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  country TEXT NOT NULL DEFAULT 'USA'
);

-- Create passengers table
CREATE TABLE public.passengers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  booking_id UUID NOT NULL,
  name TEXT NOT NULL,
  age INTEGER NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_booking
      FOREIGN KEY (booking_id)
      REFERENCES public.bookings(id)
      ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX idx_bookings_user_email ON public.bookings(user_email);
CREATE INDEX idx_passengers_booking_id ON public.passengers(booking_id);
CREATE INDEX idx_train_schedules_train_id ON public.train_schedules(train_id);
CREATE INDEX idx_train_classes_train_id ON public.train_classes(train_id);

-- Enable Row Level Security
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.passengers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trains ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.train_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.train_classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stations ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for all users" ON public.bookings 
  FOR SELECT USING (true);

CREATE POLICY "Enable insert access for all users" ON public.bookings 
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update access for all users" ON public.bookings 
  FOR UPDATE USING (true);

CREATE POLICY "Enable read access for all users" ON public.passengers 
  FOR SELECT USING (true);

CREATE POLICY "Enable insert access for all users" ON public.passengers 
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable read access for all users" ON public.trains 
  FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON public.train_schedules 
  FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON public.train_classes 
  FOR SELECT USING (true);

CREATE POLICY "Enable read access for all users" ON public.stations 
  FOR SELECT USING (true);

-- Grant permissions
GRANT ALL ON public.bookings TO authenticated;
GRANT ALL ON public.bookings TO anon;
GRANT ALL ON public.passengers TO authenticated;
GRANT ALL ON public.passengers TO anon;
GRANT SELECT ON public.trains TO authenticated;
GRANT SELECT ON public.trains TO anon;
GRANT SELECT ON public.train_schedules TO authenticated;
GRANT SELECT ON public.train_schedules TO anon;
GRANT SELECT ON public.train_classes TO authenticated;
GRANT SELECT ON public.train_classes TO anon;
GRANT SELECT ON public.stations TO authenticated;
GRANT SELECT ON public.stations TO anon;
