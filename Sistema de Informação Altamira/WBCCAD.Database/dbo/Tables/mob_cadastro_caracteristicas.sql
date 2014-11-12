CREATE TABLE [dbo].[mob_cadastro_caracteristicas] (
    [tipo]                         NVARCHAR (20) NULL,
    [caracteristica]               NVARCHAR (20) NULL,
    [descricao]                    NVARCHAR (20) NULL,
    [sigla]                        NVARCHAR (20) NULL,
    [e_padrao]                     BIT           NULL,
    [idMobCadastroCaracteristicas] INT           IDENTITY (1, 1) NOT NULL
);

