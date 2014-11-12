CREATE TABLE [dbo].[Tipo_Revisao_Proposta] (
    [cd_tipo_revisao_proposta] INT          NOT NULL,
    [nm_tipo_revisao_proposta] VARCHAR (40) NULL,
    [sg_tipo_revisao_proposta] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Proposta] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_proposta] ASC) WITH (FILLFACTOR = 90)
);

