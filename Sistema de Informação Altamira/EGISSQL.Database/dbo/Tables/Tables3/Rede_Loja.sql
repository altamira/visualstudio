CREATE TABLE [dbo].[Rede_Loja] (
    [cd_rede_loja]           INT          NOT NULL,
    [nm_rede_loja]           VARCHAR (30) NULL,
    [sg_rede_loja]           CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [qt_total_bandeira_rede] FLOAT (53)   NULL,
    [qt_total_loja_rede]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Rede_Loja] PRIMARY KEY CLUSTERED ([cd_rede_loja] ASC) WITH (FILLFACTOR = 90)
);

