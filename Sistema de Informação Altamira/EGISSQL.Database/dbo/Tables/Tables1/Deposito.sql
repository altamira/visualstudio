CREATE TABLE [dbo].[Deposito] (
    [cd_deposito]          INT          NOT NULL,
    [nm_deposito]          VARCHAR (40) NULL,
    [sg_deposito]          CHAR (10)    NULL,
    [nm_fantasia_deposito] VARCHAR (15) NULL,
    [cd_fase_produto]      INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_planta]            INT          NULL,
    CONSTRAINT [PK_Deposito] PRIMARY KEY CLUSTERED ([cd_deposito] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Deposito_Planta] FOREIGN KEY ([cd_planta]) REFERENCES [dbo].[Planta] ([cd_planta])
);

