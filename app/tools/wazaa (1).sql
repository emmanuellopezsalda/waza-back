-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-09-2024 a las 00:19:44
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

SELECT m.message_text, m.sent_at, m.id_sender 
FROM chats c 
INNER JOIN messages m 
ON c.id = m.id_chat 
WHERE c.id = id_chat 
ORDER BY m.sent_at DESC 
LIMIT 1;


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
(4, 1, 3);

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
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_status` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `messages`
--

INSERT INTO `messages` (`id`, `id_chat`, `id_sender`, `message_text`, `sent_at`, `id_status`) VALUES
(1, 1, 1, 'hola', '2024-09-25 22:20:56', NULL),
(2, 1, 2, 'h', '2024-09-25 22:21:08', NULL),
(3, 4, 1, 'asjdlksjad', '2024-09-26 20:33:25', NULL),
(4, 4, 1, 'asjdlksjad', '2024-09-26 20:33:25', NULL),
(5, 1, 1, 'dfdf', '2024-09-26 20:34:06', NULL),
(6, 4, 1, 'kk', '2024-09-26 20:37:03', NULL),
(7, 1, 1, 'jajajaj', '2024-09-26 20:44:34', NULL),
(8, 4, 1, 'ff', '2024-09-26 20:44:36', NULL),
(9, 4, 1, 'ff', '2024-09-26 20:44:36', NULL),
(10, 1, 1, 'jajajddd', '2024-09-26 20:49:27', NULL),
(11, 1, 1, 'jajajddd', '2024-09-26 20:49:27', NULL),
(12, 1, 1, 'jajajddd', '2024-09-26 20:49:27', NULL),
(13, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(14, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(15, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(16, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(17, 1, 2, 'ooo', '2024-09-26 20:50:13', NULL),
(18, 1, 2, 'kk', '2024-09-26 20:50:36', NULL),
(19, 1, 2, 'oll', '2024-09-26 20:50:44', NULL),
(20, 1, 2, 'kk', '2024-09-26 20:55:04', NULL),
(21, 1, 2, 'mm', '2024-09-26 20:55:12', NULL),
(22, 1, 2, 'mmnnn', '2024-09-26 20:57:16', NULL),
(23, 1, 1, 'df', '2024-09-26 20:57:25', NULL),
(24, 4, 1, 'ff', '2024-09-26 21:00:39', NULL),
(25, 1, 2, 'ggg', '2024-09-26 21:25:50', NULL),
(26, 1, 2, 'fff', '2024-09-26 21:25:53', NULL),
(27, 1, 2, 'ff', '2024-09-26 21:25:56', NULL),
(28, 1, 2, 'mm', '2024-09-26 21:26:35', NULL),
(29, 1, 2, 'mm', '2024-09-26 21:26:36', NULL),
(30, 1, 2, 'mm', '2024-09-26 21:26:36', NULL),
(31, 1, 2, 'ff', '2024-09-26 21:27:07', NULL),
(32, 1, 2, 'ff', '2024-09-26 21:27:08', NULL),
(33, 1, 2, 'ffff', '2024-09-26 21:27:29', NULL),
(34, 1, 2, 'sdfsdf', '2024-09-26 21:28:10', NULL),
(35, 1, 2, 'ff', '2024-09-26 21:28:11', NULL),
(36, 1, 2, 'jkfkjfjjk', '2024-09-26 21:34:01', NULL),
(37, 1, 2, 'kjfjfdkg', '2024-09-26 21:34:01', NULL),
(38, 1, 2, 'kjlkjljkljlj', '2024-09-26 21:36:38', NULL),
(39, 1, 2, 'kk', '2024-09-26 21:36:52', NULL),
(40, 1, 2, 'jsdljslkjdf', '2024-09-26 21:44:03', NULL),
(41, 1, 2, 'asdjakjdksa', '2024-09-26 21:44:35', NULL),
(42, 1, 2, 'aksjdkajsd', '2024-09-26 21:44:46', NULL),
(43, 1, 2, 'asdasd', '2024-09-26 21:45:55', NULL),
(44, 1, 2, 'sfsfsd', '2024-09-26 21:46:11', NULL),
(45, 1, 2, 'kjasjdk', '2024-09-26 21:46:23', NULL),
(46, 1, 2, 'aklsdjakjds', '2024-09-26 21:46:23', NULL),
(47, 1, 2, 'aksjdkasljd', '2024-09-26 21:46:24', NULL),
(48, 4, 3, 'kjkjl', '2024-09-26 21:48:41', NULL),
(49, 4, 3, 'kjkj', '2024-09-26 21:48:42', NULL),
(50, 1, 2, 'hola', '2024-09-26 21:49:13', NULL),
(51, 1, 2, '1', '2024-09-26 21:49:13', NULL),
(52, 1, 2, '2', '2024-09-26 21:49:14', NULL),
(53, 1, 2, '3', '2024-09-26 21:49:14', NULL),
(54, 4, 3, '1', '2024-09-26 21:49:29', NULL),
(55, 4, 3, '2', '2024-09-26 21:49:29', NULL),
(56, 4, 3, '3', '2024-09-26 21:49:30', NULL),
(57, 4, 3, '5', '2024-09-26 21:49:53', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `status`
--

DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `status`
--

INSERT INTO `status` (`id`, `status`) VALUES
(1, 'Seen'),
(2, 'Unseen');

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
(3, 'es ', '6');

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
  ADD KEY `sender` (`id_sender`),
  ADD KEY `status` (`id_status`);

--
-- Indices de la tabla `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT de la tabla `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  ADD CONSTRAINT `sender` FOREIGN KEY (`id_sender`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `status` FOREIGN KEY (`id_status`) REFERENCES `status` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
