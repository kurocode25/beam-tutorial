-- create User table
create table users (
  id UUID not null unique default gen_random_uuid() primary key, 
  email varchar(255) not null unique,
  name varchar(64) not null default 'nameless',
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now()
)
;
-- create Profile Table
create table profiles (
  id UUID not null unique default gen_random_uuid() primary key, 
  user__id UUID not null unique references users (id) on delete cascade,
  location varchar(64) null,
  message varchar(255) null
)
;
-- create Category table
create table categories (
  id UUID not null unique default gen_random_uuid() primary key, 
  slug varchar(64) not null unique,
  name varchar(64) not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now()
)
;
-- create Post table
create table posts (
  id UUID not null unique default gen_random_uuid() primary key, 
  user__id UUID not null references users (id) on delete restrict,
  category__id UUID not null references categories (id) on delete restrict,
  slug varchar(64) not null unique,
  title varchar(255) not null default '',
  markdown text not null default '',
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now()
)
;
-- create Post table
create table tags (
  id UUID not null unique default gen_random_uuid() primary key, 
  slug varchar(64) not null unique,
  name varchar(64) not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now()
)
;
-- create Post Tag mapping table
create table posts_tags (
  id UUID not null unique default gen_random_uuid() primary key, 
  post__id UUID not null references posts (id) on delete cascade,
  tag__id UUID not null references tags (id) on delete cascade
)
;
