CREATE TABLE `albums` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `description` varchar(1000) default NULL,
  `creator_id` int(11) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `author_id` int(11) default NULL,
  `content` varchar(1000) default NULL,
  `created_at` datetime default NULL,
  `comment_object_type` varchar(100) default NULL,
  `comment_object_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `description` varchar(1000) default NULL,
  `creator_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `image` varchar(200) default NULL,
  `album_id` int(11) default NULL,
  `view_count` int(11) default '0',
  `comments_count` int(11) default '0',
  `zanns_count` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `first_name` varchar(100) default NULL,
  `last_name` varchar(100) default NULL,
  `avatar` varchar(200) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zanns` (
  `id` int(11) NOT NULL auto_increment,
  `zanner_id` int(11) default NULL,
  `zanned_at` datetime default NULL,
  `zannee_type` varchar(20) default NULL,
  `zannee_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_info (version) VALUES (5)