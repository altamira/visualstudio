CREATE TABLE [dbo].[Tipo_Calculo_Orcamento] (
    [cd_tipo_calculo_orcamento] INT          NOT NULL,
    [nm_tipo_calculo_orcamento] VARCHAR (40) NULL,
    [sg_tipo_calculo_orcamento] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Calculo_Orcamento] PRIMARY KEY CLUSTERED ([cd_tipo_calculo_orcamento] ASC) WITH (FILLFACTOR = 90)
);

