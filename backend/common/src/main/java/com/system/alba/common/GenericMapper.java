package com.system.alba.common;

import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

public interface GenericMapper<Destination, Source> {

    Destination sourceToDestination(Source source);
    Source destinationToSource(Destination destination);

    List<Destination> sourceListToDestinationList(List<Source> sourceList);
    List<Source> destinationListToSourceList(List<Destination> destinationList);
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateSourceToDestination(Source source, @MappingTarget Destination destination);
}
