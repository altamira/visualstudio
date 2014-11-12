CREATE TABLE [dbo].[Tipo_Revisao_Consulta] (
    [cd_tipo_revisao_consulta] INT          NOT NULL,
    [nm_tipo_revisao_consulta] VARCHAR (40) NULL,
    [sg_tipo_revisao_consulta] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Consulta] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_consulta] ASC) WITH (FILLFACTOR = 90)
);

