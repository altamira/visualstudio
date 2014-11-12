CREATE VIEW vw_Modulo
AS 
SELECT cd_modulo, nm_modulo, cd_ordem_modulo, sg_modulo,
ic_vincular_cadeia_valor, cadeia_valor.nm_cadeia_valor, ic_liberado, qt_hora_implantacao_modulo, ic_fluxo_modulo, ic_web_modulo
FROM Modulo
left join Cadeia_Valor
on Modulo.cd_cadeia_valor = Cadeia_valor.cd_cadeia_valor
