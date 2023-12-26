-- insert Users
insert into users (id, name, email) values ('d7196102-51e5-40e1-974b-8bea6216e5a4', 'Kuro', 'kuro@example.com');
insert into users (id, name, email) values ('7bd4278a-944a-4ded-83fb-55e9598612e0', 'Tama', 'tama@example.com');
insert into users (id, name, email) values ('56d9e92f-8ae5-41a5-aae2-e95f310f3667', 'Siro', 'siro@example.com');
insert into users (id, name, email) values ('6b5e357b-3c4f-424e-acb0-f641067a4bcc', 'Tora', 'tora@example.com');
insert into users (id, name, email) values ('9c0a4e9e-2230-4246-addc-500b7a8318f8', 'Kiji', 'kiji@example.com');
insert into users (id, name, email) values ('327e148f-1f73-4d5f-a85c-a2feb4f2a176', 'Koko', 'koko@example.com');

-- insert Profiles
insert into profiles (user__id, location, message) values ('d7196102-51e5-40e1-974b-8bea6216e5a4', 'Tokyo', 'Hello!');
insert into profiles (user__id, location, message) values ('7bd4278a-944a-4ded-83fb-55e9598612e0', 'Osaka', 'Hello!');
insert into profiles (user__id, location, message) values ('56d9e92f-8ae5-41a5-aae2-e95f310f3667', 'Kyoto', 'Hello!');
insert into profiles (user__id, location, message) values ('6b5e357b-3c4f-424e-acb0-f641067a4bcc', 'Hakata', 'Hello!');
insert into profiles (user__id, location, message) values ('9c0a4e9e-2230-4246-addc-500b7a8318f8', 'Tokyo', 'Hello!');
insert into profiles (user__id, location, message) values ('327e148f-1f73-4d5f-a85c-a2feb4f2a176', 'Osaka', 'Hello!');

-- insert Categories
insert into categories (id, name, slug) values ('28820269-3dd7-41c3-9391-53025e2418e5', 'Programming', 'programming');
insert into categories (id, name, slug) values ('8506d426-b444-4e95-9bac-afb4004ac891', 'Web', 'web');
insert into categories (id, name, slug) values ('211ff88b-34e3-47b1-b2e5-9eb5a442a5d7', 'Misc', 'misc');
insert into categories (id, name, slug) values ('f544d3ab-c90c-47d2-979b-35ca3e0e49ed', 'Development', 'development');

-- insert Tags
insert into tags (id, name, slug) values ('fea736f7-fd6e-4e8f-8004-a8d02e9a134a', 'Haskell', 'haskell');
insert into tags (id, name, slug) values ('e5500b73-caf4-47cd-ae2a-e9977c1ccddc', 'Rust', 'rust');
insert into tags (id, name, slug) values ('2feb1020-76fb-4b31-bab6-6a5cf2407a0e', 'Python', 'python');
insert into tags (id, name, slug) values ('6041d6dd-843d-418a-adf2-83e4a06596dd', 'Servant', 'servant');
insert into tags (id, name, slug) values ('f39bceae-f30e-4784-9efd-395307f92fc3', 'Django', 'django');

-- insert Posts
insert into posts (id, user__id, category__id, slug, title, markdown) values
  ( 'b5a9cc28-3f40-440a-abb8-84f788da5631'
  , 'd7196102-51e5-40e1-974b-8bea6216e5a4'
  , '8506d426-b444-4e95-9bac-afb4004ac891'
  , 'sample-posts-01'
  , 'Sample Post Title 01'
  , '## Sample'
  )
;
insert into posts (id, user__id, category__id, slug, title, markdown) values
  ( '54b5eba9-f844-4dee-83cf-05af90ba0dc9'
  , '7bd4278a-944a-4ded-83fb-55e9598612e0'
  , '8506d426-b444-4e95-9bac-afb4004ac891'
  , 'sample-posts-02'
  , 'Sample Post Title 02'
  , '## Sample'
  )
;
insert into posts (id, user__id, category__id, slug, title, markdown) values
  ( '61ce9f6f-a4d3-47da-9b53-75a8a0380f99'
  , 'd7196102-51e5-40e1-974b-8bea6216e5a4'
  , 'f544d3ab-c90c-47d2-979b-35ca3e0e49ed'
  , 'sample-posts-03'
  , 'Sample Post Title 03'
  , '## Sample'
  )
;

-- insert Posts_Tags
insert into posts_tags (post__id, tag__id) values ('b5a9cc28-3f40-440a-abb8-84f788da5631', 'fea736f7-fd6e-4e8f-8004-a8d02e9a134a');
insert into posts_tags (post__id, tag__id) values ('b5a9cc28-3f40-440a-abb8-84f788da5631', '6041d6dd-843d-418a-adf2-83e4a06596dd');
insert into posts_tags (post__id, tag__id) values ('54b5eba9-f844-4dee-83cf-05af90ba0dc9', 'f39bceae-f30e-4784-9efd-395307f92fc3');
insert into posts_tags (post__id, tag__id) values ('54b5eba9-f844-4dee-83cf-05af90ba0dc9', '2feb1020-76fb-4b31-bab6-6a5cf2407a0e');
insert into posts_tags (post__id, tag__id) values ('61ce9f6f-a4d3-47da-9b53-75a8a0380f99', 'e5500b73-caf4-47cd-ae2a-e9977c1ccddc');

