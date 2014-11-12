CREATE TABLE [dbo].[Tipo_Maquina_Parada] (
    [cd_tipo_maquina_parada] INT          NOT NULL,
    [nm_tipo_maquina_parada] VARCHAR (30) NOT NULL,
    [sg_tipo_maquina_parada] CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Maquina_Parada] PRIMARY KEY CLUSTERED ([cd_tipo_maquina_parada] ASC) WITH (FILLFACTOR = 90)
);

