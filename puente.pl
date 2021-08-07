maximo(UnNumero, OtroNumero, Maximo) :-
  Maximo is max(UnNumero, OtroNumero).

posibilidad(ListaPersonas, PersonasPosibles) :-
  subconjunto(ListaPersonas, PersonasPosibles),
  length(PersonasPosibles, Longitud),
  between(1, 2, Longitud).

subconjunto([],[]).
subconjunto([X|L1],[X|L2]) :-
	subconjunto(L1,L2).
subconjunto([_|L1],L2) :-
	subconjunto(L1,L2).

% ---------------------------------------------------------------------------
%   De acá para arriba hay predicados auxiliares
% ---------------------------------------------------------------------------

tiempo(ana,1).
tiempo(belen,2).
tiempo(carla,5).
tiempo(diana,8).


tiempo(Personas, TiempoTotal) :-
    findall(Tiempo, (member(Persona, Personas), tiempo(Persona, Tiempo)), Tiempos),
    max_list(Tiempos, TiempoTotal).


movimiento(PersonasEnOrigenAntes, PersonasEnOrigenDespues, PersonasEnDestinoAntes, PersonasEnDestinoDespues, TiempoQueLleva, origen_a_destino, cruzaronDesde(origen_a_destino, Personas)) :-
    PersonasEnOrigenAntes \= [],
    cruce(PersonasEnOrigenAntes, PersonasEnOrigenDespues, PersonasEnDestinoAntes, PersonasEnDestinoDespues, Personas, TiempoQueLleva).

movimiento(PersonasEnOrigenAntes, PersonasEnOrigenDespues, PersonasEnDestinoAntes, PersonasEnDestinoDespues, TiempoQueLleva, destino_a_origen, cruzaronDesde(destino_a_origen, Personas)) :-
    PersonasEnDestinoAntes \= [],
    cruce(PersonasEnDestinoAntes, PersonasEnDestinoDespues, PersonasEnOrigenAntes, PersonasEnOrigenDespues, Personas, TiempoQueLleva).



cruce(PersonasEnInicioAntes, PersonasEnInicioDespues, PersonasEnFinalAntes, PersonasEnFinalDespues, PersonasPosibles, TiempoQueLleva) :-
    posibilidad(PersonasEnInicioAntes, PersonasPosibles),
    subtract(PersonasEnInicioAntes, PersonasPosibles, PersonasEnInicioDespues),
    append(PersonasEnFinalAntes, PersonasPosibles, PersonasEnFinalDespues),
    tiempo(PersonasPosibles, TiempoQueLleva).



% Caso Base
prueba([], PersonasEnDestino, TiempoAcumulado, TiempoMaximo, _, []) :-
    member(ana, PersonasEnDestino),
    member(belen, PersonasEnDestino),
    member(carla, PersonasEnDestino),
    member(diana, PersonasEnDestino),
    TiempoAcumulado =< TiempoMaximo.

% Caso Recursivo
prueba(PersonasEnOrigen, PersonasEnDestino, TiempoAcumulado, TiempoMaximo, Direccion, [MovimientoActual|ProximoMovimiento]) :-
    TiempoAcumulado =< TiempoMaximo,
    movimiento(PersonasEnOrigen, PersonasEnOrigenDespues, PersonasEnDestino, PersonasEnDestinoDespues, TiempoQueLleva, Direccion, MovimientoActual),
    NuevoTiempoAcumulado is TiempoAcumulado + TiempoQueLleva,
    siguiente(Direccion, SiguienteDireccion),
    prueba(PersonasEnOrigenDespues, PersonasEnDestinoDespues, NuevoTiempoAcumulado, TiempoMaximo, SiguienteDireccion, ProximoMovimiento).

siguiente(origen_a_destino, destino_a_origen).
siguiente(destino_a_origen, origen_a_destino).
