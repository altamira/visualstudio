CREATE TABLE [dbo].[Tipo_Equipamento] (
    [cd_tipo_equipamento] INT          NOT NULL,
    [nm_tipo_equipamento] VARCHAR (30) NOT NULL,
    [sg_tipo_equipamento] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Equipamento] PRIMARY KEY CLUSTERED ([cd_tipo_equipamento] ASC) WITH (FILLFACTOR = 90)
);

