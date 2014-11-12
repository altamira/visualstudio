CREATE TABLE [dbo].[Fonte_Mercado] (
    [cd_fonte_mercado] INT          NOT NULL,
    [nm_fonte_mercado] VARCHAR (40) NULL,
    [sg_fonte_mercado] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Fonte_Mercado] PRIMARY KEY CLUSTERED ([cd_fonte_mercado] ASC) WITH (FILLFACTOR = 90)
);

