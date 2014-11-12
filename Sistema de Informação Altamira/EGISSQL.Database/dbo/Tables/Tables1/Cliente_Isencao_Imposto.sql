CREATE TABLE [dbo].[Cliente_Isencao_Imposto] (
    [cd_cliente]             INT          NOT NULL,
    [ic_pis_cliente]         CHAR (1)     NULL,
    [ic_cofins_cliente]      CHAR (1)     NULL,
    [ic_icms_cliente]        CHAR (1)     NULL,
    [ic_ipi_cliente]         CHAR (1)     NULL,
    [cd_dispositivo_legal]   INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_isencao_cliente] VARCHAR (60) NULL,
    [cd_tributacao]          INT          NULL,
    CONSTRAINT [PK_Cliente_Isencao_Imposto] PRIMARY KEY CLUSTERED ([cd_cliente] ASC),
    CONSTRAINT [FK_Cliente_Isencao_Imposto_Tributacao] FOREIGN KEY ([cd_tributacao]) REFERENCES [dbo].[Tributacao] ([cd_tributacao])
);

