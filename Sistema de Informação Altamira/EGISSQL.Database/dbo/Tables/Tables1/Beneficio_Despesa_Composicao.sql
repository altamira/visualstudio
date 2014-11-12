CREATE TABLE [dbo].[Beneficio_Despesa_Composicao] (
    [cd_beneficio]             INT          NOT NULL,
    [cd_tipo_despesa]          INT          NOT NULL,
    [nm_obs_beneficio_despesa] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Beneficio_Despesa_Composicao] PRIMARY KEY CLUSTERED ([cd_beneficio] ASC, [cd_tipo_despesa] ASC),
    CONSTRAINT [FK_Beneficio_Despesa_Composicao_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

