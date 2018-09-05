CREATE TABLE IF NOT EXISTS `elecConsume`(
   `user_id` VARCHAR(12) NOT NULL ,
   `elec_value` VARCHAR(1500) NOT NULL,
   `ctime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ,
   PRIMARY KEY ( `user_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `detectRes`(
   `user_id` VARCHAR(12) NOT NULL ,
   `prop` FLOAT NOT NULL,
   `ctime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ,
   PRIMARY KEY ( `user_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `userInfo`(
   `user_id` VARCHAR(12) NOT NULL ,
   `user_name` VARCHAR(40) NOT NULL,
   `address` VARCHAR(100) NOT NULL,
   `zone_name` VARCHAR(30) NOT NULL,
   `station` VARCHAR(30) NOT NULL,
   PRIMARY KEY ( `user_id` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE userinfo ADD ctime  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ;


CREATE TABLE IF NOT EXISTS `metaTable`(
   `index` INT UNSIGNED AUTO_INCREMENT ,
   `start_time` DATE NOT NULL,
   `end_time` DATE NOT NULL,
   `zone_num` INT UNSIGNED NOT NULL,
   `user_num` INT UNSIGNED NOT NULL,
   `ctime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ,
   PRIMARY KEY ( `index` )
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for `userlogin`
-- ----------------------------
DROP TABLE IF EXISTS `userlogin`;
CREATE TABLE `userlogin` (
  `id` int(8) unsigned zerofill NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `ctime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;