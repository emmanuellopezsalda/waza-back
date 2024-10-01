-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-09-2024 a las 22:53:49
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
CREATE  PROCEDURE `SP_GET_CHATS` (IN `p_id_chat` INT(11), IN `p_user_id` INT(11))   BEGIN
    SELECT 
        m.*, 
        CASE 
            WHEN c.id_user_1 = p_user_id THEN c.id_user_2  -- Si p_user_id es id_user_1, devuelve id_user_2
            WHEN c.id_user_2 = p_user_id THEN c.id_user_1  -- Si p_user_id es id_user_2, devuelve id_user_1
        END AS other_user_id  -- ID del otro usuario
    FROM 
        messages m
    INNER JOIN 
        chats c ON m.id_chat = c.id  -- Unir la tabla de mensajes con la de chats para acceder a id_user_1 e id_user_2
    WHERE 
        m.id_chat = p_id_chat  -- Filtrar por el ID del chat
    AND 
        p_user_id IN (c.id_user_1, c.id_user_2);  -- Asegurarse de que p_user_id sea uno de los usuarios del chat
END$$

DROP PROCEDURE IF EXISTS `SP_GET_CHATS_BY_USER`$$
CREATE  PROCEDURE `SP_GET_CHATS_BY_USER` (IN `p_user_id` INT)   BEGIN
    SELECT 
        c.id AS chat_id, 
        CASE 
            WHEN c.id_user_1 = p_user_id THEN c.id_user_2  -- Si p_user_id es id_user_1, devuelve id_user_2
            WHEN c.id_user_2 = p_user_id THEN c.id_user_1  -- Si p_user_id es id_user_2, devuelve id_user_1
        END AS other_user_id,  -- ID del otro usuario
        CASE 
            WHEN c.id_user_1 = p_user_id THEN u2.name      -- Nombre del otro usuario si p_user_id es id_user_1
            WHEN c.id_user_2 = p_user_id THEN u1.name      -- Nombre del otro usuario si p_user_id es id_user_2
        END AS other_user_name  -- Nombre del otro usuario
    FROM 
        chats c
    INNER JOIN 
        users u1 ON c.id_user_1 = u1.id  -- Unir con tabla de usuarios para obtener datos de id_user_1
    INNER JOIN 
        users u2 ON c.id_user_2 = u2.id  -- Unir con tabla de usuarios para obtener datos de id_user_2
    WHERE 
        p_user_id IN (c.id_user_1, c.id_user_2);  -- Solo seleccionar chats donde p_user_id esté en id_user_1 o id_user_2
END$$

DROP PROCEDURE IF EXISTS `SP_GET_USERS`$$
CREATE  PROCEDURE `SP_GET_USERS` ()   BEGIN
    SELECT * FROM users;
END$$

DROP PROCEDURE IF EXISTS `SP_INSERT_MESSAGE`$$
CREATE  PROCEDURE `SP_INSERT_MESSAGE` (IN `p_id_chat` INT, IN `p_id_sender` INT, IN `p_message_text` TEXT)   BEGIN
    INSERT INTO messages (id_chat, id_sender, message_text)
    VALUES (p_id_chat, p_id_sender, p_message_text);
END$$

DROP PROCEDURE IF EXISTS `SP_LAST_MESSAGE`$$
CREATE  PROCEDURE `SP_LAST_MESSAGE` (IN `id_chat` INT(11), IN `p_user_id` INT(11))   BEGIN
    -- Traer el último mensaje del chat, ordenado por `sent_at` y el `id` del mensaje
    SELECT 
        m.message_text, 
        m.sent_at, 
        m.id_sender,
        m.id_status 
    FROM 
        messages m 
    INNER JOIN 
        chats c ON c.id = m.id_chat 
    WHERE 
        c.id = id_chat 
    ORDER BY 
        m.sent_at DESC, 
        m.id DESC  -- Asegurar que el último mensaje sea único
    LIMIT 1;

    -- Contar los mensajes no leídos del otro usuario
    SELECT 
        COUNT(*) AS unread_messages_count
    FROM 
        messages m
    INNER JOIN 
        chats c ON c.id = m.id_chat
    WHERE 
        c.id = id_chat
        AND m.id_sender <> p_user_id  -- Solo contar mensajes del otro usuario
        AND (m.id_status IS NULL OR m.id_status <> 1);  -- Contar los que no han sido vistos
END$$

DROP PROCEDURE IF EXISTS `SP_LOGIN`$$
CREATE  PROCEDURE `SP_LOGIN` (IN `_name` VARCHAR(50), IN `_phone` VARCHAR(100))   BEGIN

SELECT * FROM users u WHERE u.name = _name AND u.phone_number = _phone;

END$$

DROP PROCEDURE IF EXISTS `SP_MARK_SEEN`$$
CREATE  PROCEDURE `SP_MARK_SEEN` (IN `p_id_chat` INT(11), IN `p_id_sender` INT(11))   BEGIN

UPDATE messages m SET id_status = 1  WHERE m.id_chat = p_id_chat AND m.id_sender = p_id_sender;

END$$

DROP PROCEDURE IF EXISTS `SP_POST_CHAT`$$
CREATE  PROCEDURE `SP_POST_CHAT` (IN `p_id_user_1` INT, IN `p_id_user_2` INT)   BEGIN
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
(1, 1, 1, 'hola', '2024-09-28 19:03:04', 1),
(2, 1, 2, 'h', '2024-09-28 19:02:06', 1),
(3, 4, 1, 'asjdlksjad', '2024-09-26 20:33:25', NULL),
(4, 4, 1, 'asjdlksjad', '2024-09-26 20:33:25', NULL),
(5, 1, 1, 'dfdf', '2024-09-28 19:03:04', 1),
(6, 4, 1, 'kk', '2024-09-26 20:37:03', NULL),
(7, 1, 1, 'jajajaj', '2024-09-28 19:03:04', 1),
(8, 4, 1, 'ff', '2024-09-26 20:44:36', NULL),
(9, 4, 1, 'ff', '2024-09-26 20:44:36', NULL),
(10, 1, 1, 'jajajddd', '2024-09-28 19:03:04', 1),
(11, 1, 1, 'jajajddd', '2024-09-28 19:03:04', 1),
(12, 1, 1, 'jajajddd', '2024-09-28 19:03:04', 1),
(13, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(14, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(15, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(16, 4, 1, 'ooooo', '2024-09-26 20:49:31', NULL),
(17, 1, 2, 'ooo', '2024-09-28 19:02:06', 1),
(18, 1, 2, 'kk', '2024-09-28 19:02:06', 1),
(19, 1, 2, 'oll', '2024-09-28 19:02:06', 1),
(20, 1, 2, 'kk', '2024-09-28 19:02:06', 1),
(21, 1, 2, 'mm', '2024-09-28 19:02:06', 1),
(22, 1, 2, 'mmnnn', '2024-09-28 19:02:06', 1),
(23, 1, 1, 'df', '2024-09-28 19:03:04', 1),
(24, 4, 1, 'ff', '2024-09-26 21:00:39', NULL),
(25, 1, 2, 'ggg', '2024-09-28 19:02:06', 1),
(26, 1, 2, 'fff', '2024-09-28 19:02:06', 1),
(27, 1, 2, 'ff', '2024-09-28 19:02:06', 1),
(28, 1, 2, 'mm', '2024-09-28 19:02:06', 1),
(29, 1, 2, 'mm', '2024-09-28 19:02:06', 1),
(30, 1, 2, 'mm', '2024-09-28 19:02:06', 1),
(31, 1, 2, 'ff', '2024-09-28 19:02:06', 1),
(32, 1, 2, 'ff', '2024-09-28 19:02:06', 1),
(33, 1, 2, 'ffff', '2024-09-28 19:02:06', 1),
(34, 1, 2, 'sdfsdf', '2024-09-28 19:02:06', 1),
(35, 1, 2, 'ff', '2024-09-28 19:02:06', 1),
(36, 1, 2, 'jkfkjfjjk', '2024-09-28 19:02:06', 1),
(37, 1, 2, 'kjfjfdkg', '2024-09-28 19:02:06', 1),
(38, 1, 2, 'kjlkjljkljlj', '2024-09-28 19:02:06', 1),
(39, 1, 2, 'kk', '2024-09-28 19:02:06', 1),
(40, 1, 2, 'jsdljslkjdf', '2024-09-28 19:02:06', 1),
(41, 1, 2, 'asdjakjdksa', '2024-09-28 19:02:06', 1),
(42, 1, 2, 'aksjdkajsd', '2024-09-28 19:02:06', 1),
(43, 1, 2, 'asdasd', '2024-09-28 19:02:06', 1),
(44, 1, 2, 'sfsfsd', '2024-09-28 19:02:06', 1),
(45, 1, 2, 'kjasjdk', '2024-09-28 19:02:06', 1),
(46, 1, 2, 'aklsdjakjds', '2024-09-28 19:02:06', 1),
(47, 1, 2, 'aksjdkasljd', '2024-09-28 19:02:06', 1),
(48, 4, 3, 'kjkjl', '2024-09-27 22:50:43', 1),
(49, 4, 3, 'kjkj', '2024-09-27 22:50:43', 1),
(50, 1, 2, 'hola', '2024-09-28 19:02:06', 1),
(51, 1, 2, '1', '2024-09-28 19:02:06', 1),
(52, 1, 2, '2', '2024-09-28 19:02:06', 1),
(53, 1, 2, '3', '2024-09-28 19:02:06', 1),
(54, 4, 3, '1', '2024-09-27 22:50:43', 1),
(55, 4, 3, '2', '2024-09-27 22:50:43', 1),
(56, 4, 3, '3', '2024-09-27 22:50:43', 1),
(57, 4, 3, '5', '2024-09-27 22:50:43', 1),
(58, 1, 1, 'sdfjksjfk', '2024-09-28 19:03:04', 1),
(59, 1, 1, 'asdasd', '2024-09-28 19:03:04', 1),
(60, 1, 1, 'asdkasdkad', '2024-09-28 19:03:04', 1),
(61, 1, 1, 'ajsdkladslk', '2024-09-28 19:03:04', 1),
(62, 1, 1, 'asjkdksad', '2024-09-28 19:03:04', 1),
(63, 4, 1, 'ff', '2024-09-27 22:09:36', NULL),
(64, 4, 1, 'ff', '2024-09-27 22:09:36', NULL),
(65, 4, 1, 'kdkkk', '2024-09-27 22:27:27', NULL),
(66, 4, 1, 'kdkkk', '2024-09-27 22:27:27', NULL),
(67, 4, 1, 'kk', '2024-09-27 22:28:40', NULL),
(68, 4, 1, 'gg', '2024-09-27 22:30:50', NULL),
(69, 4, 1, 'gg', '2024-09-27 22:31:50', NULL),
(70, 4, 1, 'ff', '2024-09-27 22:34:02', NULL),
(71, 4, 1, 'gg', '2024-09-27 22:34:33', NULL),
(72, 4, 1, 'gg', '2024-09-27 22:34:44', NULL),
(73, 4, 1, 'gg', '2024-09-27 22:35:01', NULL),
(74, 4, 1, 'gf', '2024-09-27 22:35:02', NULL),
(75, 4, 1, 'g', '2024-09-27 22:35:03', NULL),
(76, 4, 1, 'h', '2024-09-27 22:35:03', NULL),
(77, 4, 1, 'f', '2024-09-27 22:35:04', NULL),
(78, 4, 1, 'g', '2024-09-27 22:35:04', NULL),
(79, 1, 2, 'jkkj', '2024-09-28 19:02:06', 1),
(80, 1, 1, 'oo', '2024-09-28 19:03:04', 1),
(81, 1, 1, 'hola', '2024-09-28 19:03:04', 1),
(82, 1, 2, 'bien o ', '2024-09-28 19:02:06', 1),
(83, 1, 2, 'bien', '2024-09-28 19:02:06', 1),
(84, 1, 1, 'asdhjsd', '2024-09-28 19:03:04', 1),
(85, 1, 2, 'kfkgg', '2024-09-28 19:02:06', 1),
(86, 1, 2, 'hola', '2024-09-28 19:02:06', 1),
(87, 1, 1, 'q', '2024-09-28 19:03:04', 1),
(88, 4, 1, 'gg', '2024-09-27 22:41:15', NULL),
(89, 4, 1, 'gg', '2024-09-27 22:41:15', NULL),
(90, 4, 1, 'a', '2024-09-27 22:41:20', NULL),
(91, 4, 1, 'a', '2024-09-27 22:41:20', NULL),
(92, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(93, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(94, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(95, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(96, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(97, 1, 1, 'f', '2024-09-28 19:03:04', 1),
(98, 4, 1, 'g', '2024-09-27 22:42:02', NULL),
(99, 4, 1, 'g', '2024-09-27 22:42:08', NULL),
(100, 4, 1, 'p', '2024-09-27 22:42:18', NULL),
(101, 1, 1, 'v', '2024-09-28 19:03:04', 1),
(102, 1, 1, 'v', '2024-09-28 19:03:04', 1),
(103, 1, 1, 'm', '2024-09-28 19:03:04', 1),
(104, 1, 1, 'm', '2024-09-28 19:03:04', 1),
(105, 1, 1, 'ff', '2024-09-28 19:03:04', 1),
(106, 1, 1, 'asad', '2024-09-28 19:03:04', 1),
(107, 1, 1, 'sd', '2024-09-28 19:03:04', 1),
(108, 1, 1, 'asd', '2024-09-28 19:03:04', 1),
(109, 1, 1, 'as', '2024-09-28 19:03:04', 1),
(110, 1, 1, 'd', '2024-09-28 19:03:04', 1),
(111, 1, 1, 'ds', '2024-09-28 19:03:04', 1),
(112, 1, 1, 'ad', '2024-09-28 19:03:04', 1),
(113, 4, 1, 'f', '2024-09-27 22:43:21', NULL),
(114, 4, 1, 'f', '2024-09-27 22:43:21', NULL),
(115, 1, 1, 'asfaf', '2024-09-28 19:03:04', 1),
(116, 1, 1, 'asfaf', '2024-09-28 19:03:04', 1),
(117, 1, 1, 'asfaf', '2024-09-28 19:03:04', 1),
(118, 1, 1, '1', '2024-09-28 19:03:04', 1),
(119, 1, 1, '1', '2024-09-28 19:03:04', 1),
(120, 4, 1, '2', '2024-09-27 22:45:12', NULL),
(121, 4, 1, '2', '2024-09-27 22:45:14', NULL),
(122, 1, 1, '3', '2024-09-28 19:03:04', 1),
(123, 4, 1, '4', '2024-09-27 22:45:27', NULL),
(124, 1, 2, 'hola', '2024-09-28 19:02:06', 1),
(125, 1, 1, 'g', '2024-09-28 19:03:04', 1),
(126, 4, 1, 'g', '2024-09-27 22:45:42', NULL),
(127, 4, 1, 'asfaf', '2024-09-27 22:46:43', NULL),
(128, 1, 1, 'kk', '2024-09-28 19:03:04', 1),
(129, 1, 2, 'jasjdsad', '2024-09-28 19:20:33', 1),
(130, 1, 2, 'kalsdjad', '2024-09-28 19:20:33', 1),
(131, 1, 2, 'fff', '2024-09-28 19:20:33', 1),
(132, 1, 2, 'afasf', '2024-09-28 19:20:33', 1),
(133, 1, 2, 'asfasf', '2024-09-28 19:20:33', 1),
(134, 1, 2, 'dfasfaf', '2024-09-28 19:20:33', 1),
(135, 1, 2, 'asfsaf', '2024-09-28 19:20:33', 1),
(136, 1, 2, 'asfsaf', '2024-09-28 19:20:33', 1),
(137, 1, 2, 'asdsad', '2024-09-28 19:20:33', 1),
(138, 1, 2, 'asfaf', '2024-09-28 19:20:33', 1),
(139, 1, 2, 'asfasf', '2024-09-28 19:20:33', 1),
(140, 1, 2, 'asfaf', '2024-09-28 19:20:33', 1),
(141, 1, 2, 'ggg', '2024-09-28 19:20:33', 1),
(142, 1, 2, 'hhj', '2024-09-28 19:20:33', 1),
(143, 1, 2, 'hkh', '2024-09-28 19:20:33', 1),
(144, 1, 2, 'kjhkjh', '2024-09-28 19:20:33', 1),
(145, 1, 2, 'asfsa', '2024-09-28 19:20:33', 1),
(146, 1, 2, 'asfa', '2024-09-28 19:20:33', 1),
(147, 1, 2, 'asfa', '2024-09-28 19:20:33', 1),
(148, 1, 2, 'fasf', '2024-09-28 19:20:33', 1),
(149, 1, 2, 'asf', '2024-09-28 19:20:33', 1),
(150, 1, 2, 'asf', '2024-09-28 19:20:33', 1),
(151, 1, 2, 'sa', '2024-09-28 19:20:33', 1),
(152, 1, 2, 'fa', '2024-09-28 19:20:33', 1),
(153, 1, 2, 'sfa', '2024-09-28 19:20:33', 1),
(154, 1, 2, 'sf', '2024-09-28 19:20:33', 1),
(155, 1, 2, 'asf', '2024-09-28 19:20:33', 1),
(156, 1, 2, 'af', '2024-09-28 19:20:33', 1),
(157, 1, 2, 'saf', '2024-09-28 19:20:33', 1),
(158, 1, 2, 'asf', '2024-09-28 19:20:33', 1),
(159, 1, 2, 'sf', '2024-09-28 19:20:33', 1),
(160, 1, 2, 'a', '2024-09-28 19:20:33', 1),
(161, 1, 2, 'fa', '2024-09-28 19:20:33', 1),
(162, 1, 2, 'f', '2024-09-28 19:20:33', 1),
(163, 1, 2, 'afs', '2024-09-28 19:20:33', 1),
(164, 1, 2, 'a', '2024-09-28 19:20:33', 1),
(165, 1, 2, 'fa', '2024-09-28 19:20:33', 1),
(166, 1, 2, 'f', '2024-09-28 19:20:33', 1),
(167, 1, 2, 'f', '2024-09-28 19:20:33', 1),
(168, 1, 2, 'fasdsad', '2024-09-28 19:36:00', 1),
(169, 1, 2, 'asdasf', '2024-09-28 19:36:00', 1),
(170, 1, 2, 'asfaf', '2024-09-28 19:36:00', 1),
(171, 1, 2, 'asdsa', '2024-09-28 19:36:00', 1),
(172, 1, 2, 'jasdsa', '2024-09-28 19:36:00', 1),
(173, 1, 2, 'asfaf', '2024-09-28 19:36:00', 1),
(174, 1, 2, 'asdsa', '2024-09-28 19:36:00', 1),
(175, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(176, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(177, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(178, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(179, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(180, 1, 2, 'a', '2024-09-28 19:36:00', 1),
(181, 1, 2, 'k', '2024-09-28 19:36:00', 1),
(182, 1, 2, 'k', '2024-09-28 19:36:00', 1),
(183, 1, 2, 'k', '2024-09-28 19:36:00', 1),
(184, 1, 2, 'k', '2024-09-28 19:36:00', 1),
(185, 1, 2, 'k', '2024-09-28 19:36:00', 1),
(186, 1, 2, 'ff', '2024-09-28 19:36:00', 1),
(187, 1, 2, 'asd', '2024-09-28 19:36:00', 1),
(188, 1, 2, 'ada', '2024-09-28 19:36:00', 1),
(189, 1, 2, 'ada', '2024-09-28 19:36:00', 1),
(190, 1, 2, 'm', '2024-09-28 19:36:00', 1),
(191, 1, 2, 'm', '2024-09-28 19:36:00', 1),
(192, 1, 2, 'm', '2024-09-28 19:36:00', 1),
(193, 1, 2, 's', '2024-09-28 19:36:00', 1),
(194, 1, 2, 's', '2024-09-28 19:36:00', 1),
(195, 1, 2, 'd', '2024-09-28 19:41:01', 1),
(196, 1, 2, 'f', '2024-09-28 19:41:01', 1),
(197, 1, 2, 'k', '2024-09-28 19:41:01', 1),
(198, 1, 2, 'k', '2024-09-28 19:41:01', 1),
(199, 1, 2, 'klsdfjlsdjf', '2024-09-28 19:41:01', 1),
(200, 1, 2, 'skdjfskdjf', '2024-09-28 19:41:01', 1),
(201, 1, 2, 'skdjfskjf', '2024-09-28 19:41:01', 1),
(202, 1, 2, 'sfdjjsdkfs', '2024-09-28 19:41:01', 1),
(203, 1, 2, 'sdfkskdfjs', '2024-09-28 19:41:01', 1),
(204, 1, 2, 'asd', '2024-09-28 19:41:01', 1),
(205, 1, 2, 'adsa', '2024-09-28 19:41:01', 1),
(206, 1, 2, 'ada', '2024-09-28 19:41:01', 1),
(207, 1, 2, 'dad', '2024-09-28 19:41:01', 1),
(208, 1, 2, 'ad', '2024-09-28 19:41:01', 1),
(209, 1, 2, 'ad', '2024-09-28 19:41:01', 1),
(210, 1, 2, 'd', '2024-09-28 19:41:01', 1),
(211, 1, 2, 'd', '2024-09-28 19:41:01', 1),
(212, 1, 2, 'ad', '2024-09-28 19:41:01', 1),
(213, 1, 2, 'f', '2024-09-28 19:41:01', 1),
(214, 1, 2, 'f', '2024-09-28 19:41:01', 1),
(215, 1, 2, 'afasf', '2024-09-28 19:41:01', 1),
(216, 1, 2, 'ada', '2024-09-28 19:41:01', 1),
(217, 1, 2, 'ada', '2024-09-28 19:41:01', 1),
(218, 1, 2, 'dad', '2024-09-28 19:41:01', 1),
(219, 1, 1, 'fdfd', '2024-09-28 20:32:16', 1),
(220, 1, 1, 'asfaf', '2024-09-28 20:32:16', 1),
(221, 1, 1, 'asfaf', '2024-09-28 20:32:16', 1),
(222, 1, 1, 'asf', '2024-09-28 20:32:16', 1),
(223, 1, 1, 'saf', '2024-09-28 20:32:16', 1),
(224, 1, 1, 'af', '2024-09-28 20:32:16', 1),
(225, 1, 1, 'saf', '2024-09-28 20:32:16', 1),
(226, 1, 1, 'af', '2024-09-28 20:32:16', 1),
(227, 1, 1, 'a', '2024-09-28 20:32:16', 1),
(228, 1, 1, 'fa', '2024-09-28 20:32:16', 1),
(229, 1, 1, 'fa', '2024-09-28 20:32:16', 1),
(230, 1, 1, 'f', '2024-09-28 20:32:16', 1),
(231, 1, 1, 'f', '2024-09-28 20:32:16', 1),
(232, 1, 1, 'fff', '2024-09-28 20:33:38', 1),
(233, 1, 1, 'sdfsdf', '2024-09-28 20:33:38', 1),
(234, 1, 1, 'sdfsdf', '2024-09-28 20:33:38', 1),
(235, 1, 1, 'sdfsdf', '2024-09-28 20:33:38', 1),
(236, 1, 1, 'hola', '2024-09-28 20:34:08', 1),
(237, 1, 1, 'adios', '2024-09-28 20:37:44', 1),
(238, 1, 1, 'hola2', '2024-09-28 20:37:44', 1),
(239, 1, 2, 'kjahsdas', '2024-09-28 20:37:48', 1),
(240, 1, 2, 'asfjaksf', '2024-09-28 20:37:48', 1),
(241, 1, 2, 'hola', '2024-09-28 20:40:52', 1),
(242, 1, 2, 'asjdjsad', '2024-09-28 20:41:35', 1),
(243, 1, 2, 'laksdk', '2024-09-28 20:41:35', 1),
(244, 1, 2, 'laksdsald', '2024-09-28 20:41:35', 1),
(245, 1, 2, 'alskdaldkj', '2024-09-28 20:41:35', 1),
(246, 1, 2, 'hola 1', '2024-09-28 20:41:35', 1),
(247, 1, 2, 'hola 2', '2024-09-28 20:41:35', 1),
(248, 1, 2, 'hola 3', '2024-09-28 20:41:35', 1),
(249, 1, 2, 'afasf', '2024-09-28 20:43:04', 1),
(250, 1, 1, 'sfaf', '2024-09-28 20:44:58', 1),
(251, 1, 1, 'asfaf', '2024-09-28 20:44:58', 1),
(252, 1, 1, 'asfaf', '2024-09-28 20:44:58', 1),
(253, 1, 1, 'asf', '2024-09-28 20:44:58', 1),
(254, 1, 1, 'saf', '2024-09-28 20:44:58', 1),
(255, 1, 1, 'as', '2024-09-28 20:44:58', 1),
(256, 1, 1, 'fa', '2024-09-28 20:44:58', 1),
(257, 1, 1, 'sf', '2024-09-28 20:44:58', 1),
(258, 1, 1, 'asf', '2024-09-28 20:44:58', 1),
(259, 1, 1, 'a', '2024-09-28 20:44:58', 1),
(260, 1, 2, 'hola 1', '2024-09-28 20:45:33', 1),
(261, 1, 2, 'hola 2', '2024-09-28 20:45:33', 1),
(262, 1, 2, 'hola 3', '2024-09-28 20:45:33', 1),
(263, 1, 2, 'hola 4', '2024-09-28 20:45:33', 1),
(264, 1, 2, 'hola 5', '2024-09-28 20:45:33', 1),
(265, 1, 1, 'F', '2024-09-28 20:51:45', 1),
(266, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(267, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(268, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(269, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(270, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(271, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(272, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(273, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(274, 1, 1, 'g', '2024-09-28 20:53:06', 1),
(275, 1, 1, 'a', '2024-09-28 20:53:06', 1);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=276;

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
