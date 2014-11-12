CREATE TABLE [dbo].[Tipo_Servico] (
    [cd_tipo_servico] INT          NOT NULL,
    [nm_tipo_servico] VARCHAR (40) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [vl_tipo_servico] FLOAT (53)   NULL,
    [sg_tipo_servico] CHAR (20)    NULL,
    CONSTRAINT [PK_Tipo_Servico] PRIMARY KEY CLUSTERED ([cd_tipo_servico] ASC) WITH (FILLFACTOR = 90)
);

