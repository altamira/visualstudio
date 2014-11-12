CREATE TABLE [dbo].[Tipo_Operacao] (
    [cd_tipo_operacao] INT          NOT NULL,
    [nm_tipo_operacao] VARCHAR (30) NULL,
    [sg_tipo_operacao] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Operacao] PRIMARY KEY CLUSTERED ([cd_tipo_operacao] ASC) WITH (FILLFACTOR = 90)
);

