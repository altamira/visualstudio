CREATE TABLE [dbo].[Tipo_Refeicao] (
    [cd_tipo_refeicao] INT          NOT NULL,
    [nm_tipo_refeicao] VARCHAR (40) NULL,
    [sg_tipo_refeicao] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [vl_tipo_refeicao] FLOAT (53)   NULL,
    [pc_tipo_refeicao] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Refeicao] PRIMARY KEY CLUSTERED ([cd_tipo_refeicao] ASC) WITH (FILLFACTOR = 90)
);

