CREATE TABLE [dbo].[Tipo_Manutencao_Maquina] (
    [cd_tipo_manutencao_maq] INT          NOT NULL,
    [nm_tipo_manutencao_maq] VARCHAR (30) NOT NULL,
    [sg_tipo_manutencao_maq] CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Manutencao_Maquina] PRIMARY KEY CLUSTERED ([cd_tipo_manutencao_maq] ASC) WITH (FILLFACTOR = 90)
);

