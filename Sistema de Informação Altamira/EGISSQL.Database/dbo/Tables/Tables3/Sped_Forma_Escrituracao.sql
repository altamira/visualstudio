CREATE TABLE [dbo].[Sped_Forma_Escrituracao] (
    [cd_forma_escrituracao] INT          NOT NULL,
    [nm_forma_escrituracao] VARCHAR (60) NULL,
    [sg_forma_escrituracao] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [qt_fonte_forma]        FLOAT (53)   NULL,
    [nm_titulo_forma]       VARCHAR (60) NULL,
    [ic_tipo_forma]         CHAR (1)     NULL,
    [qt_ordem_forma]        FLOAT (53)   NULL,
    [cd_conta]              INT          NULL,
    [nm_natureza_livro]     VARCHAR (80) NULL,
    [cd_livro]              INT          NULL,
    [qt_linha_livro]        INT          NULL,
    CONSTRAINT [PK_Sped_Forma_Escrituracao] PRIMARY KEY CLUSTERED ([cd_forma_escrituracao] ASC)
);

