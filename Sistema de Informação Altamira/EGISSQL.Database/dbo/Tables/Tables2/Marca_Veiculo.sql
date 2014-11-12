CREATE TABLE [dbo].[Marca_Veiculo] (
    [cd_marca_veiculo]      INT          NOT NULL,
    [nm_marca_veiculo]      VARCHAR (30) NULL,
    [sg_marca_veiculo]      CHAR (10)    NULL,
    [cd_fabricante_veiculo] INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ds_marca_veiculo]      TEXT         NULL,
    CONSTRAINT [PK_cd_marca_veiculo] PRIMARY KEY CLUSTERED ([cd_marca_veiculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Fabricante_Veiculo] FOREIGN KEY ([cd_fabricante_veiculo]) REFERENCES [dbo].[Fabricante_Veiculo] ([cd_fabricante_veiculo])
);

