CREATE TABLE [dbo].[Tipo_Operacao_Maquina] (
    [cd_tipo_operacao_maquina] INT          NOT NULL,
    [nm_tipo_operacao_maquina] VARCHAR (40) NULL,
    [sg_tipo_operacao_maquina] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Operacao_Maquina] PRIMARY KEY CLUSTERED ([cd_tipo_operacao_maquina] ASC) WITH (FILLFACTOR = 90)
);

