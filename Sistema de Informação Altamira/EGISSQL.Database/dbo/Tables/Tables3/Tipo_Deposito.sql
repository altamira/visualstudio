CREATE TABLE [dbo].[Tipo_Deposito] (
    [cd_tipo_deposito] INT          NOT NULL,
    [nm_tipo_deposito] VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [ic_tipo_deposito] CHAR (1)     NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Deposito] PRIMARY KEY CLUSTERED ([cd_tipo_deposito] ASC) WITH (FILLFACTOR = 90)
);

