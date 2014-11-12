CREATE TABLE [dbo].[Tipo_Vendedor] (
    [cd_tipo_vendedor]          INT          NOT NULL,
    [nm_tipo_vendedor]          VARCHAR (30) NOT NULL,
    [sg_tipo_vendedor]          CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_comissao_tipo_vendedor] CHAR (1)     NULL,
    [ic_interno_tipo_vendedor]  CHAR (1)     NULL,
    [ic_fechar_proposta]        CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Vendedor] PRIMARY KEY CLUSTERED ([cd_tipo_vendedor] ASC) WITH (FILLFACTOR = 90)
);

