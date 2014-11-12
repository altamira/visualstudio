CREATE TABLE [dbo].[Tipo_Limite_Viagem] (
    [cd_tipo_limite_viagem] INT          NOT NULL,
    [nm_tipo_limite_viagem] VARCHAR (40) NULL,
    [sg_tipo_limite_viagem] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [vl_tipo_limite_viagem] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Limite_Viagem] PRIMARY KEY CLUSTERED ([cd_tipo_limite_viagem] ASC) WITH (FILLFACTOR = 90)
);

