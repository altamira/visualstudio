CREATE TABLE [dbo].[APC_Balanco_Composicao] (
    [cd_composicao]     INT          NOT NULL,
    [cd_conta_balanco]  INT          NOT NULL,
    [cd_tipo_conta]     INT          NULL,
    [cd_conta]          INT          NULL,
    [nm_obs_composicao] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [ic_capital_giro]   CHAR (1)     NULL,
    [ic_operacional]    CHAR (1)     NULL,
    CONSTRAINT [PK_APC_Balanco_Composicao] PRIMARY KEY CLUSTERED ([cd_composicao] ASC)
);

