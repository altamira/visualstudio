CREATE TABLE [dbo].[Tipo_Objeto_Caixa] (
    [cd_tipo_objeto_caixa] INT          NOT NULL,
    [nm_tipo_objeto_caixa] VARCHAR (40) NULL,
    [sg_tipo_objeto_caixa] CHAR (10)    NULL,
    [vl_tipo_objeto_caixa] FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_tipo]              CHAR (3)     NULL,
    CONSTRAINT [PK_Tipo_Objeto_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_objeto_caixa] ASC) WITH (FILLFACTOR = 90)
);

