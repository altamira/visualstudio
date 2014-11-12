CREATE TABLE [dbo].[Tipo_Operacao_Bancaria] (
    [cd_tipo_operacao] INT          NOT NULL,
    [nm_tipo_operacao] VARCHAR (40) NULL,
    [sg_tipo_operacao] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Operacao_Bancaria] PRIMARY KEY CLUSTERED ([cd_tipo_operacao] ASC) WITH (FILLFACTOR = 90)
);

