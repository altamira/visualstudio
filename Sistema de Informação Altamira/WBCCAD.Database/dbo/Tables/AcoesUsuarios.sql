CREATE TABLE [dbo].[AcoesUsuarios] (
    [idAcaoUsuario] INT IDENTITY (1, 1) NOT NULL,
    [idAcao]        INT NOT NULL,
    [idUsuario]     INT NOT NULL,
    [Permitir]      BIT NOT NULL
);

