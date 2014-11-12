CREATE TABLE [dbo].[config_nota_fiscal] (
    [cd_config_nota_fiscal] INT          NOT NULL,
    [nm_config_nota_fiscal] VARCHAR (50) NOT NULL,
    [sg_config_nota_fiscal] CHAR (1)     NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [ic_config_nota_fiscal] CHAR (1)     NOT NULL,
    [ds_config_nota_fiscal] TEXT         NOT NULL,
    CONSTRAINT [PK_config_nota_fiscal] PRIMARY KEY CLUSTERED ([cd_config_nota_fiscal] ASC) WITH (FILLFACTOR = 90)
);

