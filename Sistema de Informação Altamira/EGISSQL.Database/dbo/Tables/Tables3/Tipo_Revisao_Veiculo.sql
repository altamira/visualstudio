CREATE TABLE [dbo].[Tipo_Revisao_Veiculo] (
    [cd_tipo_revisao] INT          NOT NULL,
    [nm_tipo_revisao] VARCHAR (40) NULL,
    [sg_tipo_revisao] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Veiculo] PRIMARY KEY CLUSTERED ([cd_tipo_revisao] ASC) WITH (FILLFACTOR = 90)
);

