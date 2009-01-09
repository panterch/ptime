CREATE TABLE `entries` (
  `id` int(11) NOT NULL auto_increment,
  `desc` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (1)