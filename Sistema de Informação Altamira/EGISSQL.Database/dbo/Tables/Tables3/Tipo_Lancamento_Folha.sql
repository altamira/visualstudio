CREATE TABLE [dbo].[Tipo_Lancamento_Folha] (
    [cd_tipo_lancamento_folha] INT          NOT NULL,
    [nm_tipo_lancamento_folha] VARCHAR (40) NOT NULL,
    [sg_tipo_lancamento_folha] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Lancamento_Folha] PRIMARY KEY CLUSTERED ([cd_tipo_lancamento_folha] ASC) WITH (FILLFACTOR = 90)
);

