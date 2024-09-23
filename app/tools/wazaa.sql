-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-09-2024 a las 23:09:15
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `wazaa`
--
CREATE DATABASE IF NOT EXISTS `wazaa` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `wazaa`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_GET_CHATS`$$
CREATE DEFINER=`` PROCEDURE `SP_GET_CHATS` (IN `p_id_chat` INT)   BEGIN
    SELECT * 
    FROM messages
    WHERE id_chat = p_id_chat;
END$$

DROP PROCEDURE IF EXISTS `SP_GET_CHATS_BY_USER`$$
CREATE DEFINER=`` PROCEDURE `SP_GET_CHATS_BY_USER` (IN `p_user_id` INT)   BEGIN
    SELECT 
        c.id AS chat_id,
        CASE 
            WHEN c.id_user_1 = p_user_id THEN u2.name 
            WHEN c.id_user_2 = p_user_id THEN u1.name 
        END AS other_user_name
    FROM 
        chats c
    INNER JOIN 
        users u1 ON c.id_user_1 = u1.id
    INNER JOIN 
        users u2 ON c.id_user_2 = u2.id
    WHERE 
        p_user_id IN (c.id_user_1, c.id_user_2);
END$$

DROP PROCEDURE IF EXISTS `SP_GET_USERS`$$
CREATE DEFINER=`` PROCEDURE `SP_GET_USERS` ()   BEGIN
    SELECT * FROM users;
END$$

DROP PROCEDURE IF EXISTS `SP_INSERT_MESSAGE`$$
CREATE DEFINER=`` PROCEDURE `SP_INSERT_MESSAGE` (IN `p_id_chat` INT, IN `p_id_sender` INT, IN `p_message_text` TEXT)   BEGIN
    INSERT INTO messages (id_chat, id_sender, message_text)
    VALUES (p_id_chat, p_id_sender, p_message_text);
END$$

DROP PROCEDURE IF EXISTS `SP_LAST_MESSAGE`$$
CREATE DEFINER=`` PROCEDURE `SP_LAST_MESSAGE` (IN `id_chat` INT(11))   BEGIN

SELECT m.message_text, m.sent_at FROM chats c INNER JOIN messages m ON c.id = m.id_chat WHERE c.id = id_chat AND m.sent_at = (SELECT MAX(m.sent_at) FROM messages m);

END$$

DROP PROCEDURE IF EXISTS `SP_LOGIN`$$
CREATE DEFINER=`` PROCEDURE `SP_LOGIN` (IN `_name` VARCHAR(50), IN `_phone` VARCHAR(100))   BEGIN

SELECT * FROM users u WHERE u.name = _name AND u.phone_number = _phone;

END$$

DROP PROCEDURE IF EXISTS `SP_POST_CHAT`$$
CREATE DEFINER=`` PROCEDURE `SP_POST_CHAT` (IN `p_id_user_1` INT, IN `p_id_user_2` INT)   BEGIN
    INSERT INTO `chats` (`id_user_1`, `id_user_2`) 
    VALUES (p_id_user_1, p_id_user_2);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chats`
--

DROP TABLE IF EXISTS `chats`;
CREATE TABLE `chats` (
  `id` int(11) NOT NULL,
  `id_user_1` int(11) DEFAULT NULL,
  `id_user_2` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `chats`
--

INSERT INTO `chats` (`id`, `id_user_1`, `id_user_2`) VALUES
(1, 1, 2),
(2, 3, 2),
(3, 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `id_chat` int(11) DEFAULT NULL,
  `id_sender` int(11) DEFAULT NULL,
  `message_text` varchar(255) DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `messages`
--

INSERT INTO `messages` (`id`, `id_chat`, `id_sender`, `message_text`, `sent_at`) VALUES
(1, 1, 1, 'Exneyder', '2024-09-19 21:46:30'),
(2, 1, 2, 'jjkdjkd', '2024-09-21 20:33:59'),
(3, 1, 2, 'asdsadsad', '2024-09-23 19:33:14'),
(4, 1, 2, 'ddd', '2024-09-23 19:35:00'),
(5, 1, 2, 'exneyder es gay', '2024-09-23 19:35:43'),
(6, 1, 2, 'asdasd', '2024-09-23 19:40:28'),
(7, 1, 2, 'fasf', '2024-09-23 19:40:31'),
(8, 1, 2, 'asfsafaf', '2024-09-23 19:40:37'),
(9, 1, 2, 'saddas', '2024-09-23 19:43:28'),
(10, 1, 2, 'asdsad', '2024-09-23 19:45:17'),
(11, 1, 2, 'asdad', '2024-09-23 19:45:31'),
(12, 1, 2, 'asdasd', '2024-09-23 19:45:50'),
(13, 1, 2, 'kajdlkjsa', '2024-09-23 19:52:51'),
(14, 1, 2, 'akldjalkjd', '2024-09-23 19:52:51'),
(15, 1, 2, 'exneyder es gay', '2024-09-23 19:52:55'),
(16, 1, 2, 'asdasd', '2024-09-23 20:40:19'),
(17, 1, 2, 'ddd', '2024-09-23 20:40:21'),
(18, 1, 2, 'asdad', '2024-09-23 20:50:10'),
(19, 1, 2, 'JIJIJAJA', '2024-09-23 20:56:23'),
(20, 1, 2, 'SADAD', '2024-09-23 21:07:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `phone_number`) VALUES
(1, 'klimber', '4'),
(2, 'vieja', '5'),
(3, 'es neider', '565756');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_chat` (`id_user_1`),
  ADD KEY `user_chat_2` (`id_user_2`);

--
-- Indices de la tabla `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat` (`id_chat`),
  ADD KEY `sender` (`id_sender`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `chats`
--
ALTER TABLE `chats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `user_chat` FOREIGN KEY (`id_user_1`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_chat_2` FOREIGN KEY (`id_user_2`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `chat` FOREIGN KEY (`id_chat`) REFERENCES `chats` (`id`),
  ADD CONSTRAINT `sender` FOREIGN KEY (`id_sender`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
