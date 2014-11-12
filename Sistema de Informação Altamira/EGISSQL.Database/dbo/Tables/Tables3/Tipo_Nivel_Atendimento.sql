CREATE TABLE [dbo].[Tipo_Nivel_Atendimento] (
    [cd_tipo_nivel_atendimento] INT          NOT NULL,
    [nm_tipo_nivel_atendimento] VARCHAR (40) NULL,
    [sg_tipo_nivel_atendimento] CHAR (10)    NULL,
    [nm_form_nivel_atendimento] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Nivel_Atendimento] PRIMARY KEY CLUSTERED ([cd_tipo_nivel_atendimento] ASC) WITH (FILLFACTOR = 90)
);

