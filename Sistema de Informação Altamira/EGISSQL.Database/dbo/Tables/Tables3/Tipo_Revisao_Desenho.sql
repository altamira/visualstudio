CREATE TABLE [dbo].[Tipo_Revisao_Desenho] (
    [cd_tipo_revisao_desenho] INT          NOT NULL,
    [nm_tipo_revisao_desenho] VARCHAR (40) NULL,
    [sg_tipo_revisao_desenho] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Desenho] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_desenho] ASC) WITH (FILLFACTOR = 90)
);

