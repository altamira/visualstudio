CREATE TABLE [dbo].[Tipo_Movimento_Pagamento] (
    [cd_tipo_movimento] INT          NOT NULL,
    [nm_tipo_movimento] VARCHAR (80) NULL,
    [sg_tipo_movimento] CHAR (10)    NULL,
    [ds_tipo_movimento] TEXT         NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Movimento_Pagamento] PRIMARY KEY CLUSTERED ([cd_tipo_movimento] ASC) WITH (FILLFACTOR = 90)
);

