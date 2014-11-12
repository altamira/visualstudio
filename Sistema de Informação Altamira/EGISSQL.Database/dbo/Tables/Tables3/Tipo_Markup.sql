CREATE TABLE [dbo].[Tipo_Markup] (
    [cd_tipo_markup]            INT          NOT NULL,
    [nm_tipo_markup]            VARCHAR (40) NOT NULL,
    [sg_tipo_markup]            CHAR (15)    NULL,
    [pc_tipo_markup]            FLOAT (53)   NOT NULL,
    [ic_tipo_markup_edita_orca] CHAR (1)     NOT NULL,
    [ic_tipo_markup_lucro]      CHAR (1)     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_pedido_tipo_markup]     CHAR (1)     NULL,
    [ic_nota_tipo_markup]       CHAR (1)     NULL,
    [ic_base_valor_bruto]       CHAR (1)     NULL,
    [ic_tipo_calculo_markup]    CHAR (1)     NULL,
    [ic_fiscal_tipo_markup]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_markup] PRIMARY KEY CLUSTERED ([cd_tipo_markup] ASC) WITH (FILLFACTOR = 90)
);

