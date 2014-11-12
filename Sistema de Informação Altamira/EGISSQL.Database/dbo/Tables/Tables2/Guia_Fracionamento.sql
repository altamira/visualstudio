CREATE TABLE [dbo].[Guia_Fracionamento] (
    [cd_guia_fracionamento] INT          NOT NULL,
    [cd_lote]               VARCHAR (25) NULL,
    [dt_guia_fracionamento] DATETIME     NULL,
    [dt_guia_fechada]       DATETIME     NULL,
    [dt_guia_cancelada]     DATETIME     NULL,
    [nm_guia_cancelada]     VARCHAR (40) NULL,
    [ic_guia_impressa]      CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_laudo]              INT          NULL,
    CONSTRAINT [PK_Guia_Fracionamento] PRIMARY KEY CLUSTERED ([cd_guia_fracionamento] ASC) WITH (FILLFACTOR = 90)
);

