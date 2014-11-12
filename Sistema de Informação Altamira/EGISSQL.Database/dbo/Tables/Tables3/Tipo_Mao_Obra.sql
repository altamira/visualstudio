CREATE TABLE [dbo].[Tipo_Mao_Obra] (
    [cd_tipo_mao_obra] INT          NOT NULL,
    [nm_tipo_mao_obra] VARCHAR (30) NOT NULL,
    [sg_tipo_mao_obra] CHAR (10)    NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Mao_Obra] PRIMARY KEY CLUSTERED ([cd_tipo_mao_obra] ASC) WITH (FILLFACTOR = 90)
);

