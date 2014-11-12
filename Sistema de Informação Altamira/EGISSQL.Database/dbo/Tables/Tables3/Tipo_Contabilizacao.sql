CREATE TABLE [dbo].[Tipo_Contabilizacao] (
    [cd_tipo_contabilizacao] INT          NOT NULL,
    [nm_tipo_contabilizacao] VARCHAR (30) NOT NULL,
    [sg_tipo_contabilizacao] CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [nm_atributo]            VARCHAR (25) NULL,
    CONSTRAINT [PK_Tipo_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_tipo_contabilizacao] ASC) WITH (FILLFACTOR = 90)
);

